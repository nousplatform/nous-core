pragma solidity ^0.4.18;


import "../safety/Validee.sol";


// The Permissions contract
contract PermissionsDb is Validee {

    mapping(address => bytes32) public permission;

    // set roleys
    constructor(address[] _user, bytes32[] _role) {
        for (uint i = 0; i < _user.length; i++) {
            permission[_user[i]] = _role[i];
        }
    }

    function setPermission(address _addr, bytes32 _role) external returns (bool) {
        if (!validate()) return false;
        permission[_addr] = _role;
        return true;
    }

}
