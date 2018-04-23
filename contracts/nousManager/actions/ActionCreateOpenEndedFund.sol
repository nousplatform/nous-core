pragma solidity ^0.4.18;


import "../fundTemplates/TemplateFundConstructorOpenEndedFund.sol";
import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {FundDbInterface as FundDb} from "../models/FundDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";


contract ActionCreateOpenEndedFund is Action {

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
        //require(Utils.emptyStringTest(_fundName));
        //require(!Utils.emptyStringTest(ownerFundIndex[_owner]));
        //require(fundsIndex[ownerFundIndex[_newOwner]] == 0x0);

        address tdb = getDougContract("templates_db");

        if(tdb == 0x0) {
            return false;
        }

        var (_addr, _overwrite, _version) = TemplatesDb(tdb).template("fund_constructor_open_ended_fund", 0);

        address _fundAddr = TemplateFundConstructorOpenEndedFund(_addr).create(DOUG, _owner, _fundName, _fundType);
        address fdb = getDougContract("fund_db");
        FundDb(fdb).addFund(_owner, _fundAddr, _fundName);
        return true;
    }
}
