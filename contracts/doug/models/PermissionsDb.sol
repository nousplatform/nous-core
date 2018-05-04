pragma solidity ^0.4.18;


import "../safety/Validee.sol";


// The Permissions contract
contract PermissionsDb is Validee {

    //mapping(bytes32 => mapping(address => uint8)) perms;
    mapping(address => bytes32) public perms;

    constructor(address _owner) {
        perms["owner"][_owner] = 255;
    }

    function setPermission(bytes32 _role, address _addr, uint8 _perm) external returns (bool) {

        // Do not overwrite owner
        if (!validate() || _perm <= 100 || perms[_role][_addr] > 200) {
            return false;
        }

        perms[_role][_owner] = _perm;
        return true;
    }

    function transferOwnership(address _newOwner) external returns (bool) {
        if (!validate()) {
            return false;
        }
        perms[_newOwner] = User({role: "owner", permLvl: 255});

    }

}
