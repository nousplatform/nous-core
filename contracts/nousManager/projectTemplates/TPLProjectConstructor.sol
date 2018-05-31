pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectConstructor} from "../../openEndFund/ProjectConstructor.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLProjectConstructor is BaseTemplate {

    bytes32 constant public TYPE_PROJECT = "Open-end Fund";
    bytes32 constant public CONTRACT_NAME = "ProjectConstructor";
    bytes32 constant public TPL_TYPE = "Constructor";

    function create(
        address _projectOwner,
        string _fundName,
        string _fundType,
        bytes32[] _names,
        address[] _addrs
    )
    external
    isActionManager_
    {
        address newContract = new ProjectConstructor(_fundName, _fundType, _names, _addrs);

        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract);
    }

}
