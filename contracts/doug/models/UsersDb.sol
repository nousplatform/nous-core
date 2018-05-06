pragma solidity ^0.4.0;

contract UsersDb {

    struct User {
        uint256 index; // userId
        bytes32 name;
        //uint256 role;
    }

    // @dev account address <to> permission
    mapping(address => User) public users;

    address[] public userIndexes;

    function UsersDb() {

    }

    function isUser(address _userAddr) public returns(bool) {
        if (userIndexes.length == 0) return false;
        return userIndexes[users[_userAddr].index] == _userAddr;
    }

    // @dev Do not overwrite user, only add.
    function addUser(address _userAddr, bytes32 _name/*, uint256 role*/) public returns(bool) {
        if (!validate()) return false;
        if (isUser(_userAddr)) return false; // todo all logic is action
        users[_userAddr] = User({
            name: _name,
            index: userIndexes.push(_userAddr) - 1
        });
        return true;
    }


}
