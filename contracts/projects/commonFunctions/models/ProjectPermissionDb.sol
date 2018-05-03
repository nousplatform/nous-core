pragma solidity ^0.4.18;


import "../safety/Validee.sol";


contract ProjectPermissionDb {

    // user address => role
    mapping(address => bytes32) public permission;

    constructor(address _nous) {
        permission[_nous] = "nous";
    }

    function setPermission(address _addr, bytes32 _role) returns (bool) {
        require(_role != "owner" && _role != "nous");

        if (!validate()) {
            return false;
        }
        perms[_addr] = _role;
    }
}
