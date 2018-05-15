pragma solidity ^0.4.18;


import {Validee} from  "../../../doug/safety/Validee.sol";
import {ProjectActionAddActions as ActionAddActions} from "../actions/ProjectActions.sol";
import {DougEnabled} from "../../../doug/safety/DougEnabled.sol";


contract ProjectActionDb is Validee {

    // This is where we keep all the actions.
    mapping (bytes32 => address) public actions;

    // To make sure we have an add action action, we need to auto generate
    // it as soon as we got the DOUG address.
    function setDougAddress(address _dougAddr) public returns (bool result) {
        require(super.setDougAddress(_dougAddr));
        //setupBaseActions();

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

    function removeAction(bytes32 _name) public returns (bool) {
        require(validate());
        require(actions[_name] != 0x0);
        actions[_name] = 0x0;
        return true;
    }
}

