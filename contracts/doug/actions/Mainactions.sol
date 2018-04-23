pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import "../safety/Validee.sol";
import {ActionDbAbstract as ActionDb} from "../models/ActionDb.sol";
import {DougInterface as Doug} from "../models/DougDb.sol";
import {ActionManagerInterface as ActionManager} from "../ActionManager.sol";
import {PermissionsDb as Permissions} from "../models/PermissionsDb.sol";


contract Action is ActionManagerEnabled, Validee {
    // Note auto accessor.
    uint8 public permission;

    function setPermission(uint8 permVal) returns (bool) {
        if(!validate()){
            return false;
        }
        permission = permVal;
    }
}

// Add action. NOTE: Overwrites currently added actions with the same name.
contract ActionAddAction is Action {

    function execute(bytes32 name, address addr) returns (bool) {
        if(!isActionManager()) {
            return false;
        }
        address adb = ContractProvider(DOUG).contracts("action_db");
        if(adb == 0x0) {
            return false;
        }
        return ActionDb(adb).addAction(name, addr);
    }
}

// Remove action. Does not allow 'addaction' to be removed, though that it can still
// be done by overwriting this action with one that allows it.
contract ActionRemoveAction is Action {

    function execute(bytes32 name) returns (bool) {
        if(!isActionManager()){
            return false;
        }
        address adb = ContractProvider(DOUG).contracts("action_db");
        if(adb == 0x0){
            return false;
        }
        if(name == "add_action"){
            return false;
        }
        return ActionDb(adb).removeAction(name);
    }

}

// Lock actions. Makes it impossible to run actions for everyone but the owner.
// It is good to unlock the actions manager while replacing parts of the system
// for example.
contract ActionLockActions is Action {

    function execute() returns (bool) {
        if(!isActionManager()){
            return false;
        }
        address am = ContractProvider(DOUG).contracts("actions");
        if(am == 0x0){
            return false;
        }
        return ActionManager(am).lock();
    }

}

// Unlock actions. Makes it possible for everyone to run actions.
contract ActionUnlockActions is Action {

    function execute() returns (bool) {
        if(!isActionManager()){
            return false;
        }
        ContractProvider dg = ContractProvider(DOUG);
        address am = dg.contracts("actions");
        if(am == 0x0){
            return false;
        }
        return ActionManager(am).unlock();
    }

}

// Add contract.
contract ActionAddContract is Action {

    function execute(bytes32 name, address addr) returns (bool) {
        if(!isActionManager()){
            return false;
        }
        Doug d = Doug(DOUG);
        return d.addContract(name,addr);
    }

}

// Remove contract.
contract ActionRemoveContract is Action {

    function execute(bytes32 name) returns (bool) {
        if(!isActionManager()){
            return false;
        }
        Doug d = Doug(DOUG);
        return d.removeContract(name);
    }

}

// The set user permission action.
contract ActionSetUserPermission is Action {

    function execute(address addr, uint8 perm) returns (bool) {
        if(!isActionManager()){
            return false;
        }
        ContractProvider dg = ContractProvider(DOUG);
        address perms = dg.contracts("perms");
        if(perms == 0x0){
            return false;
        }
        return Permissions(perms).setPermission(addr,perm);
    }

}

// The set action permission. This is the permission level required to run the action.
contract ActionSetActionPermission is Action {

    function execute(bytes32 name, uint8 perm) returns (bool) {
        if(!isActionManager()){
            return false;
        }
        ContractProvider dg = ContractProvider(DOUG);
        address adb = dg.contracts("actiondb");
        if(adb == 0x0){
            return false;
        }
        var action = ActionDb(adb).actions(name);
        Action(action).setPermission(perm);
    }

}
