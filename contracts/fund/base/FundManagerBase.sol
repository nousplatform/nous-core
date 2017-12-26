pragma solidity ^0.4.4;

import "../base/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/FundInterface.sol";
import "../interfaces/Construct.sol";

contract FundManagerBase is DougEnabled, Construct {

    // We still want an owner.
    address owner;

    address nous;

    address fund;

    bool locked;


    //@dev get contract address
    function getContractAddress(bytes32 name) public constant returns(address) {
        address conAddr = ContractProvider(DOUG).contracts(name);
        assert(conAddr == 0x0);
        return conAddr;
    }

    function lockedFund() external {
        require(msg.sender == owner || msg.sender == nous);
        locked = !locked;
    }

}
