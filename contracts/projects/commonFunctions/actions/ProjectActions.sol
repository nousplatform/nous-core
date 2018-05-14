pragma solidity ^0.4.18;


import {ActionAddActions, Action} from "../../../doug/actions/Mainactions.sol";

/**
* @notice LockedAction do not set permission
*/
contract LockedAction is Action("nous") {

    //permission lvl
    bool public locked = false;

    modifier allowExecute() {
        require(!locked);
        _;
    }

    function lockAction() external returns (bool) {
        require(validate());
        locked = true;
    }

    function unlockAction() external returns (bool) {
        require(validate());
        locked = false;
    }
}


// Add action. NOTE: Overwrites currently added actions with the same name.
contract ProjectActionAddActions is ActionAddActions, LockedAction {

    constructor() {
        permission["owner"] = false;
        permission["nous"] = true;
    }

    function execute(bytes32[] _names, address[] _addrs) public allowExecute {
        super.execute(_names, _addrs);
    }

}



