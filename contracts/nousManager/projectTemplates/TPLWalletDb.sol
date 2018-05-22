pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {WalletDb} from "../../openEndFund/models/WalletDb.sol"; // ----
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLWalletDb is BaseTemplate {

    bytes32 constant public TYPE_PROJECT = "Open-end Fund";
    bytes32 constant public CONTRACT_NAME = "WalletDb";
    bytes32 constant public TPL_TYPE = "database";

    function create(
        address _projectOwner
    )
    external
    isActionManager_
    {
        address newContract = new WalletDb();
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
