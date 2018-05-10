pragma solidity ^0.4.18;


import "./DougEnabled.sol";
import "../interfaces/ContractProvider.sol";


contract ActionManagerEnabled is DougEnabled {


    // Makes it easier to check that action manager is the caller.
    function isActionManager() internal constant returns (bool) {
        if (DOUG != 0x0) {
            address am = ContractProvider(DOUG).contracts("ActionManager");
            return msg.sender == am;
        }
        return false;
    }
}
