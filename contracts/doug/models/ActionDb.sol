pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import {ActionAddAction} from "../actions/Mainactions.sol";
import {Validee} from  "../safety/Validee.sol";


contract ActionDbAbstract {
    mapping (bytes32 => address) public actions;
    function getAction(bytes32 _name) public constant returns (address);
    function setDougAddress(address dougAddr) public returns (bool result);
    function addAction(bytes32 name, address addr) public returns (bool);
    function removeAction(bytes32 name) public returns (bool);
}

contract ActionDb is Validee {

    struct Action {
        address addr;
        uint index;
    }

    // This is where we keep all the actions.
    mapping (bytes32 => Action) public actionStruct;

    bytes32[] public actionIndex;

    function isAction(bytes32 _name) view returns(bool) {
        if(actionIndex.length == 0) return false;
        return (actionIndex[actionStruct[_name].index] == _name);
    }

    // To make sure we have an add action action, we need to auto generate
    // it as soon as we got the DOUG address.
    function setDougAddress(address _dougAddr) public returns (bool result) {
        require(super.setDougAddress(_dougAddr));

        address _addrAction = new ActionAddAction();
        // If this fails, then something is wrong with the add action contract.
        // Will be events logging these things in later parts.
        if(!DougEnabled(_addrAction).setDougAddress(_dougAddr)) {
            return false;
        }
        actionStruct["ActionAddAction"] = Action({addr: _addrAction, index: actionIndex.push("ActionAddAction") - 1});
        return true;
    }

    function addAction(bytes32 _name, address _addr/*, uint8 _permVal*/) public returns (bool) {
        if (!validate()) return false;
        // Remember we need to set the doug address for the action to be safe -
        // or someone could use a false doug to do damage to the system.
        // Normally the Doug contract does this, but actions are never added
        // to Doug - they're instead added to this lower-level CMC.
        bool sda = DougEnabled(_addr).setDougAddress(DOUG);
        if(!sda) {
            return false;
        }
        actionStruct[_name].addr = _addr;
        //actionStruct[_name].perm = _permVal;
        actionStruct[_name].index = actionIndex.push(_name) - 1;

        return true;
    }

    /// todo
    function removeAction(bytes32 _name) public returns (bool) {
        if(!validate()) return false;
        if (!isAction(_name)) return false;

        actionStruct[_name].addr = 0x0;
        return true;
    }

    /*function setPermission(bytes32 _name, uint8 _permVal) external returns (bool) {
        require(validate());
        actionStruct[_name].perm = _permVal;
    }*/

    function actions(bytes32 _name) public constant returns(address) {
        if (!isAction(_name)) revert();
        return actionStruct[_name].addr;
    }

}
