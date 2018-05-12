pragma solidity ^0.4.18;


import {TPLConstructorOpenEndedFund} from "../fundTemplates/TemplateOpenEndedFund.sol";
import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {FundDbInterface as FundDb} from "../models/FundDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";



contract ActionCreateOpenEndedFund is Action("owner") {

    /**
    * @notice Create new fund
    * @dev Is caused from a user name
    * @param _fundName Name new fund
    * @return { "fundaddress" : "new Fund address" }
    */
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

        var (_addr,) = TemplatesDb(tdb).template("TPLConstructorOpenEndedFund", 0);
        require(_addr != 0x0, "Template 'TPLConstructorOpenEndedFund = 0x0' not set.");

        address _fundAddr = TPLConstructorOpenEndedFund(_addr).create(_owner, _fundName, _fundType, _contractNames, _contractAddrs, _overWr);
        address fdb =  getContractAddress("FundDb");
        assert(FundDb(fdb).addFund(_owner, _fundAddr, _fundName));
        return true;
    }
}
