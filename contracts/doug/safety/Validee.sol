pragma solidity ^0.4.18;


import "./DougEnabled.sol";
import "../interfaces/Validator.sol";
import "../interfaces/ContractProvider.sol";


contract Validee is DougEnabled {

    modifier validate_() {
        address am = getContractAddress("ActionManager");
        require(Validator(am).validate(msg.sender)/*, "Permission denied"*/);
        _;
    }
}
