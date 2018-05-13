pragma solidity ^0.4.18;


import {ActionDb} from "../../../doug/models/ActionDb.sol";
import {ProjectActionAddAction} from "../actions/ProjectActions.sol";
import {DougEnabled} from "../../../doug/safety/DougEnabled.sol";


contract ProjectActionDb is ActionDb {

    function setDougAddress(address _dougAddr) public returns (bool result) {
        require(super.setDougAddress(_dougAddr));

        address _addrAction = new ProjectActionAddAction();
        // If this fails, then something is wrong with the add action contract.
        // Will be events logging these things in later parts.
        if(!DougEnabled(_addrAction).setDougAddress(_dougAddr)) {
            return false;
        }
        actionStruct["ActionAddAction"] = Action({addr: _addrAction, index: actionIndex.push("ActionAddAction") - 1});
        return true;
    }
}
