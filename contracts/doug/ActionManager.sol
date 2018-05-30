pragma solidity ^0.4.18;


import "./safety/DougEnabled.sol";
import "./interfaces/ContractProvider.sol";
import {ActionDbAbstract as ActionDb} from "./models/ActionDb.sol";
import {Action} from "./actions/Mainactions.sol";
import {PermissionDbInterface as PermissionDb} from "./models/PermissionDb.sol";


contract ActionManagerInterface {
    function lock() external returns (bool);
    function unlock() external returns (bool);
    function execute(bytes32 actionName, bytes data) public returns (bool);
}


contract ActionManager is DougEnabled {

    event ActionLogs(address /*indexed*/ caller, bytes32 /*indexed*/ actionName, address actionAddress, uint blockNumber);

    address internal activeAction = 0x0;

    bool locked;

    function execute(bytes32 actionName, bytes data) public returns (bool) {
        //return true;
        address actionDb = getContractAddress("ActionDb");

        // If no action with the given name exists - cancel.
        address _actnAddr = ActionDb(actionDb).actions(actionName);
        require(_actnAddr != 0x0);

        // Permissions stuff
        address pAddr = getContractAddress("PermissionDb");

        // First we check the permissions of the account that's trying to execute the action.
        bytes32 _userRole;
        bool _owned;
        ( , _userRole, _owned) = PermissionDb(pAddr).getUser(msg.sender);

        // Now we check that the action manager isn't locked down. In that case, special
        // permissions is needed.
        if (locked && !_owned) {
            revert("Action manager locked");
        }

        // Very simple system.
        Action _actn = Action(_actnAddr);
        require(_actn.permission(_userRole), "Access denied. Not permissions for action.");

        require(activeAction == 0x0, "Process busy at the moment.");

        // TODO keep up with return values from generic calls.
        // Set this as the currently active action.
        activeAction = _actnAddr;

        // Just assume it succeeds for now (important for logger).
        require(_actnAddr.call(data), "Query rejected.");
        // Now clear it.
        activeAction = 0x0;
        emit ActionLogs(msg.sender, actionName, _actnAddr, block.number);

        return true;
    }

    // Locked action manager
    function lock() external returns (bool) {
        require(msg.sender == activeAction);
        require(!locked);
        locked = true;
    }

    // Unlock action manager
    function unlock() external returns (bool) {
        require(msg.sender == activeAction);
        require(locked);
        locked = false;
    }

    // Validate can be called by a contract like the bank to check if the
    // contract calling it has permissions to do so.
    function validate(address addr) public constant returns (bool) {
        return addr == activeAction;
    }

    function resetActiveAction() public returns(bool) {
        require(msg.sender == DOUG);
        activeAction = 0x0;
        return true;
    }



}
