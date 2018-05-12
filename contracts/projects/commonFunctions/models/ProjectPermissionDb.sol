pragma solidity ^0.4.18;


import "../../../doug/models/PermissionDb.sol";


contract ProjectPermissionDb is PermissionDb {

    constructor(address _nous, address _owner)
    PermissionDb(_owner) {
        _addUser(_nous, "Nous", "nous", true);
        roles["nous"] = true;
    }
}
