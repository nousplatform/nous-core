pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import {Validee} from  "../safety/Validee.sol";

import {ActionAddActions} from "../actions/Mainactions.sol";

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

    // To make sure we have an add action action, we need to auto generate
    // it as soon as we got the DOUG address.
    function setDougAddress(address _dougAddr)
    public
    returns (bool result)
    {
        super.setDougAddress(_dougAddr);

        address _addrAction = new ActionAddActions();
        DougEnabled(_addrAction).setDougAddress(DOUG);
        actions["ActionAddActions"] = _addrAction;
        return true;
    }

    function addAction(
        bytes32 _name,
        address _addr
    )
    public
    validate_
    returns (bool)
    {
        // Remember we need to set the doug address for the action to be safe -
        // or someone could use a false doug to do damage to the system.
        // Normally the Doug contract does this, but actions are never added
        // to Doug - they're instead added to this lower-level CMC.
        DougEnabled(_addr).setDougAddress(DOUG);

        actions[_name] = _addr;

        return true;
    }

    function removeAction(bytes32 _name) public returns (bool) {
        require(validate());
        require(actions[_name] != 0x0);
        require(_name != "ActionAddActions");
        actions[_name] = 0x0;
        return true;
    }

}
