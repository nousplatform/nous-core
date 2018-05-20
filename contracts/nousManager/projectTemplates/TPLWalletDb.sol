pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {WalletDb} from "../../openEndFund/models/WalletDb.sol"; // ----


contract TPLWalletDb is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "WalletDb"; //----
    bytes32 constant TPL_NAME = "TPLWalletDb"; //----

    function create(
        address _projectOwner
    )
    external
    //validate_
    {
        address newContract = new WalletDb(); // ----
        uint _id = getId(_projectOwner, TYPE_PROJECT);
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
