pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {OpenEndedSaleDb} from "../../openEndFund/models/OpenEndedSaleDb.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract TPLOpenEndedSaleDb is BaseTemplate {

    bytes32 constant public TYPE_PROJECT = "Open-end Fund";
    bytes32 constant public CONTRACT_NAME = "OpenEndedSaleDb";
    //bytes32 constant public TPL_TYPE = "db";

    function create(
        address _projectOwner,
        uint256 _entryFee,
        uint256 _exitFee,
        uint256 _initPrice,
        uint256 _maxFundCup,
        uint256 _maxInvestors,
        uint256 _platformFee/*,
        address _nousWallet,
        address _ownerWallet*/
    )
    public
    isActionManager_
    {
        address newContract = new OpenEndedSaleDb(
                _entryFee,
                _exitFee,
                _initPrice,
                _maxFundCup,
                _maxInvestors,
                _platformFee/*,
                _nousWallet,
                _ownerWallet*/
        );
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract);
    }

}
