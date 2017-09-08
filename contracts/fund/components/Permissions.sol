pragma solidity ^0.4.4;

import "../security/FundManagerEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../models/PermissionDb.sol";

// Permissions
contract Permissions is FundManagerEnabled {

	function Permissions() {
		//super.setDougAddress(msg.sender);
	}

    // Set the permissions of an account.
    function setPermission(address addr, uint8 perm) returns (bool res) {
        if (!isFundManager()){
            return false;
        }
        address permdb = ContractProvider(DOUG).contracts("permsdb");
        if ( permdb == 0x0 ) {
            return false;
        }
        return PermissionDb(permdb).setPermission(addr, perm);
    }

}