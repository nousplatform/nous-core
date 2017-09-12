pragma solidity ^0.4.4;

import "../security/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/Construct.sol";

// Permissions database
contract PermissionDb is DougEnabled, Construct {

    mapping (address => uint8) public perms;

    mapping(bytes32 => uint8) public rolePermission;

	function construct(address foundOwner, address nousaddress){
		if (isCall) revert();

		rolePermission['nous'] = 4;
		rolePermission['owner'] = 3;
		rolePermission['manager'] = 2;
		rolePermission['investor'] = 1;
		isCall = true;
	}

    // Set the permissions of an account.
    function setPermission(address addr, uint8 perm) returns (bool res) {
        if(DOUG != 0x0){
            address permC = ContractProvider(DOUG).contracts("perms");
            if (msg.sender == permC ){
                perms[addr] = perm;
                return true;
            }
            return false;
        } else {
            return false;
        }
    }

    /*function getRolePerm(bytes32 role) returns (uint8) {
    	return rolePermission[role];
    }

    function getUserPerm(address addr) returns (uint8) {
    	return perms[addr];
    }*/

}