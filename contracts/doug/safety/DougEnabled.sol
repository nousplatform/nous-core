pragma solidity ^0.4.18;


import "../interfaces/ContractProvider.sol";


contract DougEnabled {
    address DOUG;

    function setDougAddress(address dougAddr) public returns (bool result) {
        // Once the doug address is set, don't allow it to be set again, except by the
        // doug contract itself.
        if(DOUG != 0x0 && dougAddr != DOUG) {
            return false;
        }
        DOUG = dougAddr;
        return true;
    }

    function getContractAddress(bytes32 _name) public constant returns(address) {
        address _contract;
        if (DOUG != 0x0) {
            _contract = ContractProvider(DOUG).contracts(_name);
        }
        assert(_contract != 0x0);
        return _contract;
    }

    // Makes it so that Doug is the only contract that may kill it.
    function remove() public {
        if(msg.sender == DOUG) {
            selfdestruct(DOUG);
        }
    }
}
