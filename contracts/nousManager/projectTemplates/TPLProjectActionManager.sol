pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectActionManager} from "../../openEndFund/ProjectActionManager.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLProjectActionManager is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "ProjectActionManager";
    bytes32 constant TPL_NAME = "TPLProjectActionManager";

    function create(
        address _projectOwner,
        address _nousPlatform
    )
    external
    //validate_
    {
        address newContract = new ProjectActionManager(_projectOwner, _nousPlatform);
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
