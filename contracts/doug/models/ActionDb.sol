pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import {Validee} from  "../safety/Validee.sol";

import {ActionAddActions} from "../actions/Mainactions.sol";
import {ActionRemoveAction} from "../actions/Mainactions.sol";
import {ActionLockActions} from "../actions/Mainactions.sol";
import {ActionUnlockActions} from "../actions/Mainactions.sol";
import {ActionSetUserRole} from "../actions/Mainactions.sol";
import {ActionAddUser} from "../actions/Mainactions.sol";
import {ActionSetActionPermission} from "../actions/Mainactions.sol";

contract ActionDbAbstract {
    mapping (bytes32 => address) public actions;
    function getAction(bytes32 _name) public constant returns (address);
    function setDougAddress(address dougAddr) public returns (bool result);
    function addAction(bytes32 name, address addr) public returns (bool);
    function removeAction(bytes32 name) public returns (bool);
}

contract ActionDb is Validee {

    // This is where we keep all the actions.
    mapping (bytes32 => address) public actions;

    //bytes32[] public actionIndex;

    // To make sure we have an add action action, we need to auto generate
    // it as soon as we got the DOUG address.
    function setDougAddress(address _dougAddr) public returns (bool result) {
        require(super.setDougAddress(_dougAddr));

        address _addrAction = new ActionAddActions();
        // If this fails, then something is wrong with the add action contract.
        // Will be events logging these things in later parts.
        require(DougEnabled(_addrAction).setDougAddress(DOUG));
        actions["ActionAddActions"] = _addrAction;
        return true;
    }

    function addAction(bytes32 _name, address _addr) public returns (bool) {
        require(validate());
        // Remember we need to set the doug address for the action to be safe -
        // or someone could use a false doug to do damage to the system.
        // Normally the Doug contract does this, but actions are never added
        // to Doug - they're instead added to this lower-level CMC.
        require(DougEnabled(_addr).setDougAddress(DOUG));

        actions[_name] = _addr;

        return true;
    }


    /*function setupBaseActions() internal {
        // ActionAddAction
        address _addrAction = new ActionAddActions();
        require(DougEnabled(_addrAction).setDougAddress(DOUG));
        actions["ActionAddAction"] = _addrAction;

        // ActionRemoveAction
        address _actionRemoveAction = new ActionRemoveAction();
        require(DougEnabled(_actionRemoveAction).setDougAddress(DOUG));
        actions["ActionRemoveAction"] = _actionRemoveAction;

        // ActionLockActions
        address _actionLockActions = new ActionLockActions();
        require(DougEnabled(_actionLockActions).setDougAddress(DOUG));
        actions["ActionLockActions"] = _actionLockActions;

        // _actionUnlockActions
        address _actionUnlockActions = new ActionUnlockActions();
        require(DougEnabled(_actionUnlockActions).setDougAddress(DOUG));
        actions["ActionUnlockActions"] = _actionUnlockActions;

        // ActionSetUserRole
        address _actionSetUserRole = new ActionSetUserRole();
        require(DougEnabled(_actionSetUserRole).setDougAddress(DOUG));
        actions["ActionSetUserRole"] = _actionSetUserRole;

        // ActionAddUser
        address _actionAddUser = new ActionAddUser();
        require(DougEnabled(_actionAddUser).setDougAddress(DOUG));
        actions["ActionAddUser"] = _actionAddUser;

        // ActionSetActionPermission
        address _actionSetActionPermission = new ActionSetActionPermission();
        require(DougEnabled(_actionSetActionPermission).setDougAddress(DOUG));
        actions["ActionSetActionPermission"] = _actionSetActionPermission;

    }*/


    function removeAction(bytes32 _name) public returns (bool) {
        require(validate());
        require(actions[_name] != 0x0);

        /*for (uint i = 0; i < actionIndex.length; i++) {
            if (actionIndex[i] == _name) break;
        }

        bytes32 lastAction = actionIndex[actionIndex.length - 1];
        actionIndex[i] = lastAction;
        actionIndex.length--;*/

        actions[_name] = 0x0;
        return true;
    }


}
