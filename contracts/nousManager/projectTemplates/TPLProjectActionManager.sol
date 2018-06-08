pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectActionManager} from "../../openEndFund/ProjectActionManager.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLProjectActionManager is BaseTemplate {

    bytes32 constant public TYPE_PROJECT = "Open-end Fund";
    bytes32 constant public CONTRACT_NAME = "ProjectActionManager";
    //bytes32 constant public TPL_TYPE = "ActionManager";

    function create(
        address _projectOwner,
        address _nousPlatform
    )
    external
    isActionManager_
    {
        require(_projectOwner != 0x0);
        require(_nousPlatform != 0x0);

        address newContract = new ProjectActionManager(_projectOwner, _nousPlatform);

        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract);
    }

}
