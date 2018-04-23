pragma solidity ^0.4.18;


import "../interfaces/ContractProvider.sol";


contract DougEnabled {
    address DOUG;

    function setDougAddress(address dougAddr) returns (bool result) {
        // Once the doug address is set, don't allow it to be set again, except by the
        // doug contract itself.
        if(DOUG != 0x0 && dougAddr != DOUG){
            return false;
        }
        DOUG = dougAddr;
        return true;
    }

    function getDougContract(bytes32 _name) internal returns (address) {
        address _addr = ContractProvider(DOUG).contracts(_name);
        //assert(_addr != 0x0);
        return _addr;
    }

    // Makes it so that Doug is the only contract that may kill it.
    function remove() {
        if(msg.sender == DOUG) {
            selfdestruct(DOUG);
        }
    }
}
