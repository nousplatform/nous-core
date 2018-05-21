pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectConstructor} from "../../openEndFund/ProjectConstructor.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLProjectConstructor is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "Open-end Fund";
    bytes32 constant CONTRACT_NAME = "ProjectConstructor";
    bytes32 constant TPL_NAME = "TPLProjectConstructor";

    function create(
        address _projectOwner,
        string _fundName,
        string _fundType,
        bytes32[] _names,
        address[] _addrs
    )
    external
    //validate_
    {
        address newContract = new ProjectConstructor(_fundName, _fundType, _names, _addrs);
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
