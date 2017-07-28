pragma solidity ^0.4.4;

import "./DougEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/Validator.sol";

contract Validee is DougEnabled {
    // Makes it easier to check that action manager is the caller.
    function validate() internal constant returns (bool) {
        if(DOUG != 0x0){
            address am = ContractProvider(DOUG).contracts("actions");
            if(am == 0x0){
              return false;
            }

            return Validator(am).validate(msg.sender);
        }
        return false;
    }
}

contract Tests2 is DougEnabled {

    function getAddressDoug() constant returns (address){
        return DOUG;
    }
}
