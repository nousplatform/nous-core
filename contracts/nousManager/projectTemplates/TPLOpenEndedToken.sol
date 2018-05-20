pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {OpenEndedToken} from "../../openEndFund/token/OpenEndedToken.sol"; // ---
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLOpenEndedToken is BaseTemplate { // ----

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "OpenEndedToken"; // -----
    bytes32 constant TPL_NAME = "TPLOpenEndedToken"; // -----

    function create(
        address _projectOwner,
        address _nousToken,
        string _name,
        string _symbol
    )
    external
    //validate_
    {
        address newContract = new OpenEndedToken(
            _projectOwner,
            _nousToken,
            _name,
            _symbol
        );
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }
}
