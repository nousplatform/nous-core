pragma solidity ^0.4.18;


import "../../../doug/models/UserDb.sol";


contract ProjectUserDb is UserDb {

    constructor(address _nous, address _owner)
    UserDb(_owner) {
        _addUser(_nous, "Nous", "nous", true);
    }
}
