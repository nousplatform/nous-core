pragma solidity ^0.4.18;


import "../base/FundManagerBase.sol";
import "../interfaces/PermissionProvider.sol";
import "../interfaces/ContractProvider.sol";


contract Permission is FundManagerBase {

    // Set the permissions for a given address.
    // perm_lvl
    function setPermission(address addr, bytes32 permLvl) public returns (bool) {
        require(msg.sender == owner);
        address permdb = getContractAddress("permission_db");
        return PermissionProvider(permdb).setPermission(addr, permLvl);
    }

    function checkPermission(bytes32 role) internal returns (bool) {
        if (locked == true) return false;
        address permsdb = ContractProvider(DOUG).contracts("permission_db");
        if (permsdb != 0x0) {
            PermissionProvider permComp = PermissionProvider(permsdb);
            return permComp.getUserPerm(msg.sender) != permComp.getRolePerm(role);
        }
        return false;
    }
}
