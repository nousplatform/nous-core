pragma solidity ^0.4.18;


import "./safety/DougEnabled.sol";
import "./models/UserDb.sol";
import "./interfaces/ContractProvider.sol";
import {ActionDbAbstract as ActionDb} from "./models/ActionDb.sol";
import {Action} from "./actions/Mainactions.sol";
import {/*UsersDbInterface as*/ UserDb} from "./models/UserDb.sol";
import {/*UsersDbInterface as*/ RoleDb} from "./models/RoleDb.sol";


interface ActionManagerInterface {
    function lock() public returns (bool);
    function unlock() public returns (bool);
    //function resetActiveAction() public returns(bool);
}


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

    bool locked;

    // Adding a logger here, and not in a separate contract. This is wrong.
    // Will replace with array once that's confirmed to work with structs etc.
    uint public nextEntry = 0;
    mapping(uint => ActionLogEntry) public logEntries;

    function execute(bytes32 actionName, bytes data) public returns (bool) {

        address actionDb = getContractAddress("ActionDb");

        // If no action with the given name exists - cancel.
        address actn = ActionDb(actionDb).actions(actionName);
        require(actn != 0x0);

        // Permissions stuff
        address uAddr = getContractAddress("UserDb");

        // First we check the permissions of the account that's trying to execute the action.
        var ( , _userRole, _owned) = UserDb(uAddr).getUser(msg.sender);

        // Now we check that the action manager isn't locked down. In that case, special
        // permissions is needed.
        if (locked && !_owned) {
            revert();
        }

        // Very simple system.
        Action _a = Action(actn);
        require(_a.permission(_userRole), "Access denied. Not permissions for action.");
        require(!_a.locked, "Action locked.");

        // todo locked process
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

    function lock() public returns (bool) {
        if (msg.sender != activeAction) {
            return false;
        }
        if (locked) {
            return false;
        }
        locked = true;
    }

    function unlock() public returns (bool) {
        if (msg.sender != activeAction) {
            return false;
        }
        if (!locked) {
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
        if (msg.sender != address(this)) {
            return;
        }
        ActionLogEntry memory le = logEntries[nextEntry++];
        le.caller = msg.sender;
        le.action = actionName;
        le.success = success;
        le.blockNumber = block.number;
    }

}
