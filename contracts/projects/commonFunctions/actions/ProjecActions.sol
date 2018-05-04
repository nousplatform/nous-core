pragma solidity ^0.4.18;


import {Action} from "../../../doug/actions/Mainactions.sol";


contract ProjectAction {

    // special allow for execute nous manager
    bool public specialAllow = false;

    function setSpecialAllow() {
        require(validate());
        specialAllow = true;
    }

}

// Add action. NOTE: Overwrites currently added actions with the same name.
contract ProjectActionAddAction is ActionAddAction, ProjectAction {

    constructor() {
        permissions["nous"] = true;
    }

    function execute(bytes32 name, address addr) external returns (bool) {
        if (!isActionManager()) {
            return false;
        }
        address adb = ContractProvider(DOUG).contracts("ActionDb");
        if (adb == 0x0) {
            return false;
        }
        return ActionDb(adb).addAction(name, addr);
    }
}

