pragma solidity ^0.4.4;


import "./safety/DougEnabled.sol";
import "./models/PermissionsDb.sol";
import "./interfaces/ContractProvider.sol";
import {ActionDbAbstract as ActionDb} from "./models/ActionDb.sol";
import {Action} from "./actions/Mainactions.sol";


interface ActionManagerInterface {
    function lock() returns (bool);
    function unlock() returns (bool);
}

/*interface Validator {
    function validate(address addr) constant returns (bool);
}*/


contract ActionManager is DougEnabled {

    struct ActionLogEntry {
        address caller;
        bytes32 action;
        uint blockNumber;
        bool success;
    }

    bool LOGGING = true;

    // This is where we keep the "active action".
    // TODO need to keep track of uses of (STOP) as that may cause activeAction
    // to remain set and opens up for abuse. (STOP) is used as a temporary array
    // out-of bounds exception for example (or is planned to), which means be
    // careful. Does it revert the tx entirely now, or does it come with some sort
    // of recovery mechanism? Otherwise it is still super dangerous and should never
    // ever be used. Ever.
    address activeAction;

    uint8 permToLock = 255; // Current max. 255
    bool locked;

    // Adding a logger here, and not in a separate contract. This is wrong.
    // Will replace with array once that's confirmed to work with structs etc.
    uint public nextEntry = 0;
    mapping(uint => ActionLogEntry) public logEntries;

    function ActionManager() {
        // permToLock = 255;
    }

    function test(address actn, bytes data) public constant returns(address) {
        actn.call(data);
    }

    function execute(bytes32 actionName, bytes data) returns (bool) {
        address actionDb = ContractProvider(DOUG).contracts("ActionDb");
        require(actionDb != 0x0);
        /*if (actionDb == 0x0) {
            _log(actionName,false);
            return false;
        }*/

        // If no action with the given name exists - cancel.
        address actn = ActionDb(actionDb).actions(actionName);
        require(actn != 0x0);
        /*if (actn == 0x0) {
            _log(actionName, false);
            return false;
        }*/

        // Permissions stuff
        address pAddr = ContractProvider(DOUG).contracts("PermissionDb");
        // Only check permissions if there is a permissions contract.
        if(pAddr != 0x0) {
            PermissionsDb p = PermissionsDb(pAddr);

            // First we check the permissions of the account that's trying to execute the action.
            uint8 perm = p.perms(msg.sender);

            // Now we check that the action manager isn't locked down. In that case, special
            // permissions is needed.
            if(locked && perm < permToLock) {
                _log(actionName, false);
                return false;
            }

            // Now we check the permission that is required to execute the action.
            uint8 permReq = Action(actn).permission();

            // Very simple system.
            if (perm < permReq) {
                _log(actionName,false);
                return false;
            }
        }

        // Set this as the currently active action.
        activeAction = actn;
        // TODO keep up with return values from generic calls.
        // Just assume it succeeds for now (important for logger).
        actn.call(data);
        // Now clear it.
        activeAction = 0x0;
        _log(actionName, true);
        return true;
    }

    function lock() returns (bool) {
        if(msg.sender != activeAction) {
            return false;
        }
        if(locked) {
            return false;
        }
        locked = true;
    }

    function unlock() returns (bool) {
        if(msg.sender != activeAction) {
            return false;
        }
        if(!locked) {
            return false;
        }
        locked = false;
    }

    // Validate can be called by a contract like the bank to check if the
    // contract calling it has permissions to do so.
    function validate(address addr) constant returns (bool) {
        return addr == activeAction;
    }

    function _log(bytes32 actionName, bool success) internal {
        // TODO check if this is really necessary in an internal function.
        if(msg.sender != address(this)) {
            return;
        }
        ActionLogEntry memory le = logEntries[nextEntry++];
        le.caller = msg.sender;
        le.action = actionName;
        le.success = success;
        le.blockNumber = block.number;
    }

}
