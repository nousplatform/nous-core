pragma solidity ^0.4.18;


import "../interfaces/ContractProvider.sol";


contract DougEnabled {

    address DOUG;

    function getContractAddress(bytes32 _name)
    internal
    view
    returns (address)
    {
        require(DOUG != 0x0);
        address _contract = ContractProvider(DOUG).contracts(_name);
        require(_contract != 0x0);
        return _contract;
    }

    function setDougAddress(address _dougAddr)
    public
    returns (bool)
    {
        require(DOUG == 0x0);
        DOUG = _dougAddr;
        return true;
    }

    // Makes it so that Doug is the only contract that may kill it.
    function remove()
    external
    {
        require(msg.sender == DOUG);
        selfdestruct(DOUG);
    }
}
