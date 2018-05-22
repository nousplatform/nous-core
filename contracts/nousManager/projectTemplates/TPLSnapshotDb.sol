pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {SnapshotDb} from "../../openEndFund/models/SnapshotDb.sol"; // ----
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLSnapshotDb is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "Open-end Fund";
    bytes32 constant CONTRACT_NAME = "SnapshotDb"; //----
    bytes32 constant TPL_TYPE = "database"; //----

    function create(
        address _projectOwner
    )
    external
    isActionManager_
    {
        address newContract = new SnapshotDb(); // ----
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
