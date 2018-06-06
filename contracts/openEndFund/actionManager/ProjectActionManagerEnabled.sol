pragma solidity ^0.4.18;


import "../../doug/interfaces/ContractProvider.sol";
import {DougEnabled} from "../../doug/safety/DougEnabled.sol";


contract ProjectActionManagerEnabled is DougEnabled {

    // Makes it easier to check that action manager is the caller.
    modifier isActionManager_() {
        address am = getContractAddress("ProjectActionManager");
        require(msg.sender == am);
        _;
    }
}
