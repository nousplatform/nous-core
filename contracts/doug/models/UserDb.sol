pragma solidity ^0.4.0;


import "../safety/Validee.sol";


contract UserDb  is Validee {

    struct User {
        uint256 index; // userId
        bytes32 name;
        bytes32 role;
    }

    // @dev account address <to> permission
    mapping(address => User) private userList;

    address[] public userIndexes;

    constructor(address[] _userAddr, bytes32[] _name, bytes32[] _role) public {
        for (uint i = 0; i < _userAddr.length; i++ ) {
            _addUser(_userAddr[i], _name[i], _role[i]);
        }
    }

    function isUser(address _user) internal returns(bool) {
        if (userIndexes.length == 0) return false;
        userIndexes[userList[_user].index] == _user;
    }

    function _addUser(address _userAddr, bytes32 _name, bytes32 _role) internal {
        userList[_userAddr] = User({
            name: _name,
            index: userIndexes.push(_userAddr) - 1,
            role: _role
        });
    }

    // @dev Do not overwrite user, only add.
    function addUser(address _userAddr, bytes32 _name, bytes32 _role) external returns(bool) {
        if (!validate() || isUser(_userAddr)) return false;
        _addUser(_userAddr, _name, _role);
        return true;
    }

    function setRole(address _user, bytes32 _role) external returns(bool) {
        if (!validate() || !isUser(_userAddr)) return false;
        userList[_user].role = _role;
    }

    function user(address _userAddr) public constant returns(bytes32 _name, bytes32 _role) {
        if (!isUser(_userAddr)) revert("User not found.");
        return (userList[_userAddr].name, userList[_userAddr].role);
    }

    function getUserFormIndex(uint _index) public constant returns(bytes32 _name, bytes32 _role) {
        if (!isUser(userIndexes[_index])) revert("User not found.");
        return (userList[userIndexes[_index]].name, userList[userIndexes[_index]].role);
    }

    function count() public constant returns(uint) {
        return userIndexes.length;
    }

}
