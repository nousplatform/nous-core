pragma solidity ^0.4.18;


import "./safety/DougEnabled.sol";
import "./models/PermissionsDb.sol";
import "./interfaces/ContractProvider.sol";
import {ActionDbAbstract as ActionDb} from "./models/ActionDb.sol";
import {Action} from "./actions/Mainactions.sol";


interface ActionManagerInterface {
    function lock() public returns (bool);
    function unlock() public returns (bool);
    //function resetActiveAction() public returns(bool);
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
    address activeAction = 0x0;

    uint8 permToLock = 255; // Current max. 255
    bool locked;

    // Adding a logger here, and not in a separate contract. This is wrong.
    // Will replace with array once that's confirmed to work with structs etc.
    uint public nextEntry = 0;
    mapping(uint => ActionLogEntry) public logEntries;

    function execute(bytes32 actionName, bytes data) public returns (bool) {
        //todo require security
        require(activeAction == 0x0);
        // Set this as the currently active action.
        activeAction = actn;

        address actionDb = ContractProvider(DOUG).contracts("ActionDb");
        require(actionDb != 0x0);
        /*if (actionDb == 0x0) {
            _log(actionName, false);
            return false;
        }*/

        // If no action with the given name exists - cancel.
        address actn = ActionDb(actionDb).actions(actionName);
        require(actn != 0x0);
        /*if (actn == 0x0) {
            //_log(actionName, false);
            //return false;
        }*/

        // TODO keep up with return values from generic calls.
        // Just assume it succeeds for now (important for logger).
        require(actn.call(data));
        // Now clear it.
        activeAction = 0x0;
        _log(actionName, true);
        return true;
    }

    function lock() public returns (bool) {
        if(msg.sender != activeAction) {
            return false;
        }
        if(locked) {
            return false;
        }
        locked = true;
    }

    function unlock() public returns (bool) {
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
    function validate(address addr) public constant returns (bool) {
        return addr == activeAction;
    }

    function resetActiveAction() public returns(bool) {
        require(msg.sender == DOUG);
        activeAction = 0x0;
        return true;
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
