pragma solidity ^0.4.18;


import "./DougEnabled.sol";
import "../interfaces/Validator.sol";
import "../interfaces/ContractProvider.sol";


contract Validee is DougEnabled {

    modifier validate_() {
        address am = getContractAddress("ActionManager");
        require(Validator(am).validate(msg.sender));
        _;
    }

    // Makes it easier to check that action manager is the caller.
    function validate() internal constant returns (bool) {
        if (DOUG != 0x0) {
            address am = getContractAddress("ActionManager");
            if (am == 0x0) {
                return false;
            }
            return Validator(am).validate(msg.sender);
        }
        return false;
    }
}
