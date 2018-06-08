pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {OpenEndedToken} from "../../openEndFund/token/OpenEndedToken.sol";


contract TPLOpenEndedToken is BaseTemplate { // ----

    bytes32 constant public TYPE_PROJECT = "Open-end Fund";
    bytes32 constant public CONTRACT_NAME = "OpenEndedToken";

    function create(
        address _projectOwner,
        address[] _addressToAllowPurchases,
        string _name,
        string _symbol,
        uint8 _decimals,
        address _nousWallet
    )
    external
    isActionManager_
    {
        require(_projectOwner != 0x0);

        address newContract = new OpenEndedToken(
            _projectOwner,
            _addressToAllowPurchases,
            _name,
            _symbol,
            _decimals,
            _nousWallet
        );
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract);
    }
}
