pragma solidity ^0.4.18;


import {ActionManager} from "../../doug/ActionManager.sol";
contract TPLActionManager {
    function create() public returns (address) {
        return new ActionManager();
    }
}


