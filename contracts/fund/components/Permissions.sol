pragma solidity ^0.4.4;

import "../security/FundManagerEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../models/PermissionDb.sol";
import "../interfaces/Construct.sol";

// Permissions
contract Permissions is FundManagerEnabled, Construct {

    // Set the permissions of an account.
    function setPermission(address addr, uint8 perm) returns (bool res) {
        if (!isFundManager()){
            return false;
        }
        address permdb = ContractProvider(DOUG).contracts("permissiondb");
        if ( permdb == 0x0 ) {
            return false;
        }
        return PermissionDb(permdb).setPermission(addr, perm);
    }

}