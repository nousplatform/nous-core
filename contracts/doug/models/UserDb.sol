pragma solidity ^0.4.18;


import "../safety/Validee.sol";
import {RoleDbInterface} from "./RoleDb.sol";


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

    function isUser(address _account) internal returns(bool) {
        if (userIndexes.length == 0) return false;
        userIndexes[userList[_account].index] == _account;
    }

    function _addUser(address _userAddr, bytes32 _name, bytes32 _role, bool _owned) internal {
        userList[_userAddr] = User({
            name: _name,
            role: _role,
            owned: _owned,
            index: userIndexes.push(_userAddr) - 1
        });
    }

    function validateRole(bytes32 _role) internal returns(bool) {
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
        if (!isUser(_account)) return false;
        if (!validateRole(_role)) return false;

        userList[_addr].role = _role;
        return true;
    }

    function addUser(address _account, bytes32 _name, bytes32 _role) external returns (bool) {
        if (!validate()) return false;
        if (isUser(_account)) return false;
        if (!validateRole(_role)) return false;

        _addUser(_account, _name, _role, false);
        return true;
    }

    function count() public constant returns(uint256) {
        return userIndexes.length();
    }

    function getUserFromIndex(uint256 _index) public constant returns(address _account, bytes32 _name, bytes32 _role, bool _owned) {
        User _user = userList[userIndexes[_index]];
        return (userIndexes[_index], _user.name, _user.role, _user.owned);
    }

    function getUser(address _account) public constant returns(bytes32 _name, bytes32 _role, bool _owned) {
        require(!isUser(_account), "User not exist");
        User _user = userList[_account];
        return (_user.name, _user.role, _user.owned);
    }

}
