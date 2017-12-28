pragma solidity ^0.4.18;


import "../base/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/FundInterface.sol";


contract FundManagerBase is DougEnabled {

    // We still want an owner.
    address public owner;

    address public nous;

    address public fund;

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
