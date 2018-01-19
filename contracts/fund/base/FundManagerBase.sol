pragma solidity ^0.4.18;


import "../base/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/FundInterface.sol";
import "./OwnableFunds.sol";


contract FundManagerBase is DougEnabled, OwnableFunds {

    bool public locked;

    function lockedFund() external ownerOrNous {
        locked = !locked;
    }

    //@dev get contract address
    function getContractAddress(bytes32 name) public constant returns(address) {
        address conAddr = ContractProvider(DOUG).contracts(name);
        assert(conAddr == 0x0);
        return conAddr;
    }
}
