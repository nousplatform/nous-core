pragma solidity ^0.4.18;


import {ActionAddAction} from "../../../doug/actions/Mainactions.sol";


// Add action. NOTE: Overwrites currently added actions with the same name.
contract ProjectActionAddAction is ActionAddAction {

    constructor() {
        permission["nous"] = true;
        permission["owner"] = false;
        locked = true;
    }
}



