pragma solidity ^0.4.18;

import "./DougEnabled.sol";
import "../interfaces/ContractProvider.sol";


// Base class for contracts that only allow the fundmanager to call them.
// Note that it inherits from DougEnabled
contract FundManagerEnabled is DougEnabled {

    // Makes it easier to check that fundmanager is the caller.
    modifier isFundManager() {
        require(DOUG != 0x0);
        require(ContractProvider(DOUG).contracts("fund_manager") == msg.sender);
        _;
    }
}
