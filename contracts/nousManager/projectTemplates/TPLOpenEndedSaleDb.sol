pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {OpenEndedSaleDb} from "../../openEndFund/models/OpenEndedSaleDb.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLOpenEndedSaleDb is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "Open-end Fund";
    bytes32 constant CONTRACT_NAME = "OpenEndedSaleDb";
    bytes32 constant TPL_NAME = "TPLOpenEndedSaleDb";

    function create(
        address _projectOwner,
        uint256 _entryFee,
        uint256 _exitFee,
        uint256 _initPrice,
        uint256 _maxFundCup,
        uint256 _maxInvestors,
        uint256 _managementFee
    )
    public
    //validate_
    {
        address newContract = new OpenEndedSaleDb(
                _entryFee,
                _exitFee,
                _initPrice,
                _maxFundCup,
                _maxInvestors,
                _managementFee
        );
        uint _id = getId(_projectOwner, TYPE_PROJECT);

        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
