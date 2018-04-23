pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import {ActionAddAction} from "../actions/Mainactions.sol";


contract ActionDbAbstract {
    mapping (bytes32 => address) public actions;
    function getAction(bytes32 _name) public constant returns (address);
    function setDougAddress(address dougAddr) returns (bool result);
    function addAction(bytes32 name, address addr) returns (bool);
    function removeAction(bytes32 name) returns (bool);
}

contract ActionDb is ActionManagerEnabled {

    // This is where we keep all the actions.
    mapping (bytes32 => address) public actions;

    /**
    * @notice return action
    * @param _name action name
    * @return address action
    */
    function getAction(bytes32 _name) public constant returns (address) {
        return actions[_name];
    }

    // To make sure we have an add action action, we need to auto generate
    // it as soon as we got the DOUG address.
    function setDougAddress(address dougAddr) returns (bool result) {
        super.setDougAddress(dougAddr);

        var addaction = new ActionAddAction();
        // If this fails, then something is wrong with the add action contract.
        // Will be events logging these things in later parts.
        if(!DougEnabled(addaction).setDougAddress(dougAddr)) {
            return false;
        }
        actions["addaction"] = address(addaction);
    }

    function addAction(bytes32 name, address addr) returns (bool) {
        if(!isActionManager()) {
            return false;
        }
        // Remember we need to set the doug address for the action to be safe -
        // or someone could use a false doug to do damage to the system.
        // Normally the Doug contract does this, but actions are never added
        // to Doug - they're instead added to this lower-level CMC.
        bool sda = DougEnabled(addr).setDougAddress(DOUG);
        if(!sda){
            return false;
        }
        actions[name] = addr;
        return true;
    }

    function removeAction(bytes32 name) returns (bool) {
        if (actions[name] == 0x0){
            return false;
        }
        if(!isActionManager()){
            return false;
        }
        actions[name] = 0x0;
        return true;
    }

}
