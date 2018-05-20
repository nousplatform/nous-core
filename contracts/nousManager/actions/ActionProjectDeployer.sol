pragma solidity ^0.4.23;
//pragma experimental ABIEncoderV2;


import {Action} from "../../doug/actions/Mainactions.sol";
import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";


contract ActionProjectDeployer is Action("owner") {

    function execute(
        bytes32[] _tplNames,
        bytes data
    )
    //isActionManager_
    public
    {
        return;
        address _tdb = getContractAddress("TemplatesDb");

        for (uint i = 0; i < _tplNames.length; i++) {

            address _template = TemplatesDb(_tdb).template(_tplNames[i], 0);
            require(_template != 0x0);
            data[i];
            //require(_template.call(data[i]));
        }
    }
}
