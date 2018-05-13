pragma solidity ^0.4.18;


import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {ProjectDbInterface as ProjectDb} from "../models/ProjectDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";


import {TPLConstructorOpenEndedFund} from "../fundTemplates/TPLConstructorOpenEndedFund.sol";


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
        //address _nousToken,
        //string _tokenName,
        //string _tokenSymbol//,
        bytes32[] _contractNames,
        address[] _contractAddrs,
        bool[] _overWr
    ) public returns (bool) {

        require(isActionManager());
        require(_owner != 0x0);

        address tdb = getContractAddress("TemplatesDb");

        var (_addrConst,) = TemplatesDb(tdb).template("TPLConstructorOpenEndedFund", 0);
        require(_addrConst != 0x0, "Template 'TPLConstructorOpenEndedFund = 0x0' not set.");

        address _fundAddr = TPLConstructorOpenEndedFund(_addrConst).create(_owner, _fundName, _fundType, _contractNames, _contractAddrs, _overWr);

        address fdb =  getContractAddress("ProjectDb");
        assert(ProjectDb(fdb).addFund(_owner, _fundAddr, _fundName, _fundType));



        //bytes32[] _contractNames;
        //address[] _contractAddrs;
        //bool[] _overWr;



        //var (_addrAdb, _overwrAdb, ) = TemplatesDb(tdb).template("TPLProjectActionDb", 0);
        //address _adb = TPLProjectActionDb(_addrAdb).create();
        //_contractNames.push("ActionDb");
        //_contractAddrs.push(_adb);
        //_overWr.push(_overwrAdb);




//        var (_addrAm, _overwrAm, ) = TemplatesDb(tdb).template("TPLActionManager", 0);
//        address _am = TPLActionManager(_addrAm).create();
//
//        _contractNames.push("ActionManager");
//        _contractAddrs.push(_addrAm);
//        _overWr.push(_overwrAm);



        return true;
    }
}
