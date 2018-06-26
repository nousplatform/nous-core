pragma solidity ^0.4.18;


import "../safety/Validee.sol";


interface PermissionDbInterface {
    //setters
    function setOwned(address _addr, bool _owned) external returns (bool);
    function setRole(address _addr, bytes32 _role) external returns (bool);
    function addUser(address _addr, bytes32 _name, bytes32 _role) external returns (bool);
    //getters
    function count() external view returns(uint256);
    function getUserFromIndex(uint256 _index) external view returns(address _account, bytes32 _name, bytes32 _role, bool _owned);
    function getUser(address _addr) external view returns(bytes32 _name, bytes32 _role, bool _owned);
}


// The Permissions contract
contract PermissionDb is Validee {

    // @dev name_role => special role bool true/false
    // @dev special roles, these are those that are assigned only one-time and can bypass the blocking of the manager's actions
    mapping(bytes32 => bool) roles;

    struct User {
        bytes32 name;
        bytes32 role;
        bool owned;
        uint256 index;
    }

    mapping(address => User) userList;
    address[] public userIndexes;

    // constructor for owner
    constructor(address _owner) public {
        _addUser(_owner, "Owner", "owner", true);
        roles["owner"] = true;
    }

    function _addUser(address _userAddr, bytes32 _name, bytes32 _role, bool _owned) internal {
        // if role is not special
        require(!roles[_name]);

        userList[_userAddr] = User({
            name: _name,
            role: _role,
            owned: _owned,
            index: userIndexes.push(_userAddr) - 1
        });
    }

    function addUser(address _addr, bytes32 _name, bytes32 _role) external validate_ returns (bool) {
        require(!isUser(_addr), "User exists");
        //require(!roles[_role], "Special role not assign"); // if this role not special

        _addUser(_addr, _name, _role, false);
        return true;
    }

    /**
    * @notice TODO Function works directly
    */
    function transferOwnership(address _newOwner) public {
        require(isUser(msg.sender));
        uint _index = userList[msg.sender].index;
        userIndexes[_index] = _newOwner;
        userList[_newOwner] = userList[msg.sender];
    }

    function setOwned(address _addr, bool _owned) external validate_ returns (bool) {
        require(!roles[userList[_addr].role], "User is blocked");
        userList[_addr].owned = _owned;
        return true;
    }

    /**
    * @notice Assign roley if role not special
    * @param _addr User address
    * @param _role Role to assign
    * @return bool
    */
    function setRole(address _addr, bytes32 _role) external validate_ returns (bool) {
        require(!roles[_role], "Special role not assign"); // if this role not special
        require(isUser(_addr), "User not exists");

        userList[_addr].role = _role;
        return true;
    }

    function isUser(address _account) internal view returns(bool) {
        if (userIndexes.length == 0) return false;
        return userIndexes[userList[_account].index] == _account;
    }

    function count() external view returns(uint256) {
        return userIndexes.length;
    }

    function getUserFromIndex(uint256 _index) external view returns(address _account, bytes32 _name, bytes32 _role, bool _owned) {
        require(isUser(userIndexes[_index]));
        User memory _user = userList[userIndexes[_index]];
        return (userIndexes[_index], _user.name, _user.role, _user.owned);
    }

    function getUser(address _addr)
    external
    view
    returns(bytes32 _name, bytes32 _role, bool _owned)
    {
        require(isUser(_addr));
        User memory _user = userList[_addr];
        return (_user.name, _user.role, _user.owned);
    }

}
