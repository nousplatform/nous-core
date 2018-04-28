pragma solidity ^0.4.18;


import "../fundTemplates/TemplateConstructorOpenEndedFund.sol";
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
    function execute(address _owner, string _fundName, bytes32 _fundType) public returns (bool) {

        require(isActionManager());
        require(_owner != 0x0);
        require(_fundType != bytes32(0));

        //require(Utils.emptyStringTest(_fundName));
        //require(!Utils.emptyStringTest(ownerFundIndex[_owner]));
        //require(fundsIndex[ownerFundIndex[_newOwner]] == 0x0);

        address tdb = ContractProvider(DOUG).contracts("TemplatesDb");
        require(tdb != 0x0, "Template 'TemplatesDb = 0x0' not set.");

        var (_addr,) = TemplatesDb(tdb).template("TemplateConstructorOpenEndedFund", 0);
        require(_addr != 0x0, "Template 'TemplateConstructorOpenEndedFund = 0x0' not set.");

        address _fundAddr = TemplateConstructorOpenEndedFund(_addr).create(DOUG, _owner, _fundName, _fundType);
        address fdb =  ContractProvider(DOUG).contracts("FundDb");
        assert(FundDb(fdb).addFund(_owner, _fundAddr, _fundName));
        return true;
    }
}
