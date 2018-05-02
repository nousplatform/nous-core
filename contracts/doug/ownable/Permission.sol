pragma solidity ^0.4.18;


import "../ActionManager.sol";


contract Permission is ActionManager {

//    uint8 permToLock = 255; // Current max. 255
//
//    bool locked;

    function execute(bytes32 actionName, bytes data) public returns (bool) {


        return super.execute(actionName, data);
    }
}
