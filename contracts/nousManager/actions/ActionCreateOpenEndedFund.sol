pragma solidity ^0.4.18;


import {TemplateConstructorOpenEndedFund} from "../fundTemplates/TemplateConstructorOpenEndedFund.sol";
import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {FundDbInterface as FundDb} from "../models/FundDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";
import "../../doug/interfaces/ContractProvider.sol";


contract ActionCreateOpenEndedFund is Action {

    /*function test() public constant returns(address) {
        address tdb = ContractProvider(DOUG).contracts("TemplatesDb");
        //return tdb;
        address _addr;
        bool _overwrite;
        uint _version;

        (_addr, _overwrite, _version) = TemplatesDb(tdb).template("TemplateConstructorOpenEndedFund", 0);
        return _addr;
    }*/

    /**
    * @notice Create new fund
    * @dev Is caused from a user name
    * @param _fundName Name new fund
    * @return { "fundaddress" : "new Fund address" }
    */
    //string _tokenName, string _tokenSymbol, uint8 _decimals
    function execute(
        address _owner,
        string _fundName,
        string _fundType,
        bytes32[] _contractNames,
        address[] _contractAddrs,
        bool[] _overWr
    ) public returns (bool) {

        require(isActionManager());
        require(_owner != 0x0);

        address tdb = getContractAddress("TemplatesDb");

        var (_addr,) = TemplatesDb(tdb).template("TemplateConstructorOpenEndedFund", 0);
        require(_addr != 0x0, "Template 'TemplateConstructorOpenEndedFund = 0x0' not set.");

        address _fundAddr = TemplateConstructorOpenEndedFund(_addr).create(_owner, _fundName, _fundType, _contractNames, _contractAddrs, _overWr);
        address fdb =  ContractProvider(DOUG).contracts("FundDb");
        assert(FundDb(fdb).addFund(_owner, _fundAddr, _fundName));
        return true;
    }
}
