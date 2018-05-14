pragma solidity ^0.4.18;


import "../../doug/ActionManager.sol";
//import "./models/ProjectUserDb.sol";


contract ProjectManager is ActionManager {

    /*function execute(bytes32 actionName, bytes data) public returns (bool) {

        address actionDb = getContractAddress("ActionDb");

        // If no action with the given name exists - cancel.
        address _actnAddr = ActionDb(actionDb).actions(actionName);
        require(_actnAddr != 0x0);

        // Permissions stuff
        address pAddr = getContractAddress("PermissionDb");

        // First we check the permissions of the account that's trying to execute the action.
        var ( , _userRole, _owned) = PermissionDb(pAddr).getUser(msg.sender);

        // Now we check that the action manager isn't locked down. In that case, special
        // permissions is needed.
        if (locked && !_owned) {
            revert("Action manager locked");
        }

        // Very simple system.
        Action _actn = Action(_actnAddr);
        require(_actn.permission(_userRole), "Access denied. Not permissions for action.");

        // todo locked process
        require(activeAction == 0x0, "Process busy at the moment.");

        // TODO keep up with return values from generic calls.
        // Set this as the currently active action.
        activeAction = _actnAddr;

        // Just assume it succeeds for now (important for logger).
        require(_actnAddr.call(data), "Query rejected.");
        // Now clear it.
        activeAction = 0x0;
        _log(actionName, true);
        return true;
    }*/

}
