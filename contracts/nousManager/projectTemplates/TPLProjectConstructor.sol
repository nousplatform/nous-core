pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectConstructor} from "../../openEndFund/ProjectConstructor.sol";


contract TPLProjectConstructor is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
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
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
