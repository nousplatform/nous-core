pragma solidity ^0.4.18;


import "../safety/Validee.sol";


// The Permissions contract
contract PermissionsDb is Validee {

    // This is where we keep all the permissions.
    mapping (address => uint8) public perms;

    function setPermission(address addr, uint8 perm) returns (bool) {
        if (!validate()){
            return false;
        }
        perms[addr] = perm;
    }
}
