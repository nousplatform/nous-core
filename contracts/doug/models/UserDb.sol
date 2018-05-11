pragma solidity ^0.4.18;


import "../safety/Validee.sol";
import {RoleDbInterface as RoleDb} from "./RoleDb.sol";


interface UserDbInterface {
    function setOwned(address _addr, bool _owned) external returns (bool);
    function setRole(address _addr, bytes32 _role) external returns (bool);
    function addUser(address _account, bytes32 _name, bytes32 _role) external returns (bool);
}


// The Permissions contract
contract UserDb is Validee {

    struct User {
        bytes32 role;
        bytes32 name;
        bool owned;
        uint256 index;
    }

    mapping(address => User) userList;
    address[] public userIndexes;

    // constructor for owner
    constructor(address _owner) public {
        _addUser(_owner, "Owner", "owner", true);
    }

    function _addUser(address _userAddr, bytes32 _name, bytes32 _role, bool _owned) internal {
        userList[_userAddr] = User({
            name: _name,
            role: _role,
            owned: _owned,
            index: userIndexes.push(_userAddr) - 1
        });
    }

    function isUser(address _account) public view returns(bool) {
        if (userIndexes.length == 0) return false;
        userIndexes[userList[_account].index] == _account;
    }

    function validateRole(bytes32 _role) public view returns(bool) {
        address rdb_ = getContractAddress("RoleDb");
        return RoleDb(rdb_).allowToAssign(_role);
    }

    function setOwned(address _addr, bool _owned) external returns (bool) {
        if (!validate()) return false;
        userList[_addr].owned = _owned;
        return true;
    }

    function setRole(address _addr, bytes32 _role) external returns (bool) {
        if (!validate()) return false;
        if (!isUser(_addr)) return false;
        if (!validateRole(_role)) return false;

        userList[_addr].role = _role;
        return true;
    }

    function addUser(address _addr, bytes32 _name, bytes32 _role) external returns (bool) {
        if (!validate()) return false;
        if (isUser(_addr)) return false;
        if (!validateRole(_role)) return false;

        _addUser(_addr, _name, _role, false);
        return true;
    }

    function count() public constant returns(uint256) {
        return userIndexes.length;
    }

    function getUserFromIndex(uint256 _index) public constant returns(address _account, bytes32 _name, bytes32 _role, bool _owned) {
        User memory _user = userList[userIndexes[_index]];
        return (userIndexes[_index], _user.name, _user.role, _user.owned);
    }

    function getUser(address _account) public constant returns(bytes32 _name, bytes32 _role, bool _owned) {
        require(!isUser(_account), "User not exist");
        User memory _user = userList[_account];
        return (_user.name, _user.role, _user.owned);
    }

}
