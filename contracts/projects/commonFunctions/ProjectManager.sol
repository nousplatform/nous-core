pragma solidity ^0.4.18;


import "../../doug/ActionManager.sol";
import "./models/ProjectPermissionDb.sol";


contract ProjectManager is ActionManager {

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
        byte32 _role = p.perms(msg.sender);

        // Now we check that the action manager isn't locked down. In that case, special
        // permissions is needed.
        if (locked && _role != "owner" && _role != "nous") {
            revert();
        }

        uint8 permReq = Action(actn).permission(_role);

        // Very simple system.
        if (!permReq) {
            revert();
        }

        require(activeAction == 0x0);
        // Set this as the currently active action.
        activeAction = actn;

        // TODO keep up with return values from generic calls.
        // Just assume it succeeds for now (important for logger).
        require(actn.call(data));
        // Now clear it.
        activeAction = 0x0;
        _log(actionName, true);
        return true;
    }
}
