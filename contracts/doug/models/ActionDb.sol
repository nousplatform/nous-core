pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import {ActionAddAction} from "../actions/Mainactions.sol";
import {Validee} from  "../safety/Validee.sol";


contract ActionDbAbstract {
    mapping (bytes32 => address) public actions;
    function getAction(bytes32 _name) public constant returns (address);
    function setDougAddress(address dougAddr) returns (bool result);
    function addAction(bytes32 name, address addr) returns (bool);
    function removeAction(bytes32 name) returns (bool);
}

contract ActionDb is Validee {

    struct Action {
        address addr;
        uint8 perm;
        uint index;
        //bytes32[] permRole;
    }

    // This is where we keep all the actions.
    mapping (bytes32 => Action) public actionStruct;

    bytes32[] public actionIndex;

    function isAction(bytes32 _name) internal returns(bool) {
        if(actionIndex.length == 0) return false;
        return (actionIndex[actions[_name].index] == _name);
    }

    /**
    * @notice return action
    * @param _name action name
    * @return address action
    */
    function getAction(bytes32 _name) public constant returns (address, uint8) {
        return (actionStruct[_name].addr, actions[_name].perm);
    }

    // To make sure we have an add action action, we need to auto generate
    // it as soon as we got the DOUG address.
    function setDougAddress(address _dougAddr) returns (bool result) {
        require(super.setDougAddress(_dougAddr));

        address _addrAction = new ActionAddAction();
        // If this fails, then something is wrong with the add action contract.
        // Will be events logging these things in later parts.
        if(!DougEnabled(_addAction).setDougAddress(_dougAddr)) {
            return false;
        }
        actionStruct["ActionAddAction"] = Action({addr: _addrAction, perm: 255, index: actionIndex.push(_addrAction) - 1});
        return true;
    }

    function addAction(bytes32 _name, address _addr, uint8 _permVal) returns (bool) {
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
        actionStruct[_name].perm = _permVal;
        actionStruct[_name].index = actionIndex.push(_addr) - 1;

        return true;
    }

    /// todo
//    function removeAction(bytes32 _name) returns (bool) {
//        if(!validate()) return false;
//        if (!isAction(_name)) return false;
//
//        actions[_name].addr = 0x0;
//        return true;
//    }

    function setPermission(bytes32 _name, uint8 _permVal) external returns (bool) {
        require(validate());
        actionStruct[_name].perm = _permVal;
    }

    function actions(bytes32 _name) public constant returns(address) {
        if (!isAction(_name)) revert();
        return actionStruct[_name].addr;
    }

}
