pragma solidity ^0.4.18;


import {ActionAddAction} from "../../../doug/actions/Mainactions.sol";


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
        permissions["owner"] = false;
        specialAllow = false;
    }

    function execute(bytes32 _name, address _addr) external {
        require(specialAllow);
        super.execute(_name, _addr);
    }

}

