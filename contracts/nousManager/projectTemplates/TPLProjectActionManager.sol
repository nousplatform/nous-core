pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectActionManager} from "../../openEndFund/ProjectActionManager.sol";


contract TPLProjectActionManager is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "ProjectActionManager";

    function create(
        address _projectOwner,
        address _nousPlatform
    )
    external
    validate_
    returns (address)
    {
        address newContract = new ProjectActionManager(_projectOwner, _nousPlatform);
        uint _id = ids[_projectOwner]++;
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
