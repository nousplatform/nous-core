pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {SnapshotDb} from "../../openEndFund/models/SnapshotDb.sol"; // ----
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLSnapshotDb is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "SnapshotDb"; //----
    bytes32 constant TPL_NAME = "TPLSnapshotDb"; //----

    function create(
        address _projectOwner
    )
    external
    //validate_
    {
        address newContract = new SnapshotDb(); // ----
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
