pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {WalletDb} from "../../openEndFund/models/WalletDb.sol"; // ----


contract TPLWalletDb is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "WalletDb"; //----

    function create(
        address _projectOwner
    )
    external
    validate_
    returns (address)
    {
        address newContract = new WalletDb(); // ----
        uint _id = ids[_projectOwner]++;
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
