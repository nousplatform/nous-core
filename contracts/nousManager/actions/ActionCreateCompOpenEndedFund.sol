pragma solidity ^0.4.18;


import {Action} from "../../doug/actions/Mainactions.sol";
import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {TPLComponentsOpenEndedFund} from "../fundTemplates/TemplateOpenEndedFund.sol";



contract ActionCreateCompOpenEndedFund is Action("owner") {

    function execute(address _nousManager, address _owner) {
        address tdb = getContractAddress("TemplatesDb");
        var (_addr,) = TemplatesDb(tdb).template("TPLComponentsOpenEndedFund", 0);
        //bytes32[] memory _names;
        //address[] memory _addrs;
        var (_names, _addrs) = TPLComponentsOpenEndedFund(_addr).create(_nousManager, _owner);

    }
}
