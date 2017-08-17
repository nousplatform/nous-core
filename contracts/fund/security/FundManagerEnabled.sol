pragma solidity ^0.4.4;

import "./DougEnabled.sol";
import "../interfaces/ContractProvider.sol";

// Base class for contracts that only allow the fundmanager to call them.
// Note that it inherits from DougEnabled
contract FundManagerEnabled is DougEnabled {

    // Makes it easier to check that fundmanager is the caller.
    function isFundManager() constant returns (bool) {
        if(DOUG != 0x0){
            address fm = ContractProvider(DOUG).contracts("fundManager");
            return msg.sender == fm;
        }
        return false;
    }
}