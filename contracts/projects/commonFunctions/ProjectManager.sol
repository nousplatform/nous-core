pragma solidity ^0.4.18;


import "../../doug/ActionManager.sol";
import "./models/ProjectPermissionDb.sol";


contract ProjectManager is ActionManager {

    uint8 specialPerm = 0;

    constructor() {
        permToLock = 100;
    }

    function execute(bytes32 actionName, bytes data) public returns (bool) {

        address actionDb = ContractProvider(DOUG).contracts("ActionDb");
        require(actionDb != 0x0);

        // If no action with the given name exists - cancel.
        address actn = ActionDb(actionDb).actions(actionName);
        require(actn != 0x0);

        // Permissions stuff
        address pAddr = ContractProvider(DOUG).contracts("ProjectPermissionDb");
        // Only check permissions if there is a permissions contract.
        require(pAddr != 0x0);

        ProjectPermissionDb p = ProjectPermissionDb(pAddr);
        // First we check the permissions of the account that's trying to execute the action.
        bool perm = p.perms(msg.sender);

        // Now we check that the action manager isn't locked down. In that case, special
        // permissions is needed.
        if (locked && !(perm == "owner" || perm == "nous")) {
            revert();
        }

        // First we check the permissions of the account that's trying to execute the action.
        uint8 permReqMin = Action(actn).permissionMin();
        uint8 permReqMax = Action(actn).permissionMax();

        // Very simple system.
        if ((perm > permReqMin) && (perm < permReqMax)) {
            revert("Permission denied.");
        }

        // locked process
        require(activeAction == 0x0, "Process busy at the moment.");
        // TODO keep up with return values from generic calls.
        // Set this as the currently active action.
        activeAction = actn;

        // Just assume it succeeds for now (important for logger).
        require(actn.call(data), "Query rejected.");
        // Now clear it.
        activeAction = 0x0;
        _log(actionName, true);
        return true;
    }

    function setSpecialPerms() {
        specialPerm = 10;
    }
}
