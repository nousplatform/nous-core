pragma solidity ^0.4.18;


import {Action} from "../../doug/actions/Mainactions.sol";
import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {TPLActionManager} from "../fundTemplates/TPLActionManager.sol";
import {ProjectDbInterface as ProjectDb} from "../models/ProjectDb.sol";

import {TPLProjectActionDb} from "../fundTemplates/TPLProjectActionDb.sol";

import {TPLComponentsOEFund1, TPLComponentsOEFund2, TPLComponentsOEFund3, TPLActionsOEFund} from "../fundTemplates/TPLComponentsOpenEndedFund.sol";
import {OpenEndedFund} from "../../projects/openEndedFund/OpenEndedFund.sol";


contract ActionCreateCompOEFund1 is Action("owner") {

    function execute(address _nousManager, address _owner) {

        address tdb = getContractAddress("TemplatesDb");

        TemplatesDb tpldb = TemplatesDb(tdb);

        var (_addrAdb,  ) = tpldb.template("TPLComponentsOEFund1", 0);
        var (_names, _addrs) = TPLComponentsOEFund1(_addrAdb).create();

        tpldb.addTmpContract(_owner, "contracts", _names, _addrs);

    }
}

contract ActionCreateCompOEFund2 is Action("owner") {
    function execute(address _nousManager, address _owner) {
        address tdb = getContractAddress("TemplatesDb");

        TemplatesDb tpldb = TemplatesDb(tdb);

        var (_addrAdb,  ) = tpldb.template("TPLComponentsOEFund2", 0);
        var (_names, _addrs) = TPLComponentsOEFund2(_addrAdb).create(_nousManager, _owner);

        tpldb.addTmpContract(_owner, "contracts", _names, _addrs);
    }
}

contract ActionCreateCompOEFund3 is Action("owner") {
    function execute(address _owner, address _nousToken, string _name, string _symbol) {
        address tdb = getContractAddress("TemplatesDb");

        TemplatesDb tpldb = TemplatesDb(tdb);

        var (_addrAdb,  ) = tpldb.template("TPLComponentsOEFund3", 0);
        var (_names, _addrs) = TPLComponentsOEFund3(_addrAdb).create(_owner, _nousToken, _name, _symbol);

        tpldb.addTmpContract(_owner, "contracts", _names, _addrs);
    }
}

contract ActionCreateActionsOEFund is Action("owner") {
    function execute(address _owner) {
        address tdb = getContractAddress("TemplatesDb");

        TemplatesDb tpldb = TemplatesDb(tdb);

        var (_addrAdb,  ) = tpldb.template("TPLActionsOEFund", 0);
        var (_names, _addrs) = TPLActionsOEFund(_addrAdb).create();

//        address am = getContractAddress("ActionManager");
//        for (uint i = 0; i < _names.length; i++) {
//            ActionManager(am).execute("", (bytes4(sha3("fun(uint256)")), a));
//        }


        tpldb.addTmpContract(_owner, "actions", _names, _addrs);
    }
}
