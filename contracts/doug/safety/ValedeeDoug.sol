pragma solidity ^0.4.18;


import "./DougEnabled.sol";


contract ValedeeDoug is DougEnabled {
    function isContract(bytes32 _contract) internal constant returns (bool) {
        if (DOUG != 0x0) {
            address _con = ContractProvider(DOUG).contracts(_contract);
            if (_con == 0x0) {
                return false;
            }
            return msg.sender == _con;
        }
        return false;
    }
}
