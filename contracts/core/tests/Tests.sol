pragma solidity ^0.4.0;

import "../security/DougEnabled.sol";

contract Tests is DougEnabled {

    function getAddressDoug() constant returns (address){
        return DOUG;
    }

}
