pragma solidity ^0.4.18;


import "../base/FundManagerBase.sol";
import "../interfaces/PermissionProvider.sol";
import "../interfaces/ContractProvider.sol";


contract Permission is FundManagerBase {

    bool public fundLocked = false;

    function fundStatus() external returns(bool) {
        return fundLocked;
    }

    function lockUnlockFund() external {
        require(checkPermission("owner"));
        fundLocked = !fundLocked;
    }

    // Set the permissions for a given address.
    // perm_lvl
    function setPermission(address _address, bytes32 _role, bool _status) public returns (bool) {
        require(_address != 0x0);
        require(checkPermission("owner"));
        require(_role.length > 0);

        address permdb = getContractAddress("permission_db");
        return PermissionProvider(permdb).setPermission(_address, _role, _status);
    }

    function checkPermission(bytes32 _role) internal returns (bool) {
        if (ContractProvider(DOUG).fundStatus() == true) return false;

        address permdb = getContractAddress("permission_db");
        return PermissionProvider(permdb).getPermission(_role, msg.sender);
    }

}
