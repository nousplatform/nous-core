pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {WalletDb} from "../../openEndFund/models/WalletDb.sol"; // ----
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLWalletDb is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "Open-end Fund";
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

        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}