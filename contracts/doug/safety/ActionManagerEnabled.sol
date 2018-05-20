pragma solidity ^0.4.18;


import "./DougEnabled.sol";
import "../interfaces/ContractProvider.sol";


contract ActionManagerEnabled is DougEnabled {


    // Makes it easier to check that action manager is the caller.
    modifier isActionManager_() {
        address am = getContractAddress("ActionManager");
        require(msg.sender == am, "Access denied");
        _;
    }

    function isActionManager() internal constant returns (bool) {
        if (DOUG != 0x0) {
            address am = getContractAddress("ActionManager");
            return msg.sender == am;
        }
        return false;
    }
}
