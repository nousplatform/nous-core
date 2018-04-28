pragma solidity ^0.4.18;


import "../ActionManager.sol";


contract Permission is ActionManager {

//    uint8 permToLock = 255; // Current max. 255
//
//    bool locked;

    function execute(bytes32 actionName, bytes data) public returns (bool) {
        // Permissions stuff
        address pAddr = ContractProvider(DOUG).contracts("PermissionDb");
        // Only check permissions if there is a permissions contract.
        require(pAddr != 0x0);

        PermissionsDb p = PermissionsDb(pAddr);
        // First we check the permissions of the account that's trying to execute the action.
        uint8 perm = p.perms(msg.sender);

        // Now we check that the action manager isn't locked down. In that case, special
        // permissions is needed.
        if(locked && perm < permToLock) {
            revert();
        }

        uint8 permReq = Action(actn).permission();

        // Very simple system.
        if (perm < permReq) {
            revert();
        }

        return super.execute(actionName, data);
    }
}
