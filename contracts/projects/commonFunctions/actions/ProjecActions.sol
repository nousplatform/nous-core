pragma solidity ^0.4.18;


import {ActionAddAction, Action} from "../../../doug/actions/Mainactions.sol";

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
contract ProjectActionAddAction is ActionAddAction, LockedAction {

    function execute(bytes32 _name, address _addr) public allowExecute {
        super.execute(_name, _addr);
    }

}



