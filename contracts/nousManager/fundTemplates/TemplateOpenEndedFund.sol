pragma solidity ^0.4.18;


import "../../projects/openEndedFund/OpenEndedFund.sol";


import {ActionDb} from "../../doug/models/ActionDb.sol";
import {ProjectPermissionDb} from "../../projects/commonFunctions/models/ProjectPermissionDb.sol";
import {SnapshotDb} from "../../projects/commonFunctions/models/SnapshotDb.sol";
import {WalletDb} from "../../projects/commonFunctions/models/WalletDb.sol";

import {OpenEndedSaleDb} from "../../projects/openEndedFund/models/OpenEndedSaleDb.sol";
import {OpenEndedToken} from "../../projects/openEndedFund/token/OpenEndedToken.sol";


contract TPLConstructorOpenEndedFund {
    function create( address _fundOwn, string _fundName, string _fundType, bytes32[] _names, address[] _addrs, bool[] _overWr) public
    returns (address) {
        return new OpenEndedFund(_fundOwn, _fundName, _fundType, _names, _addrs, _overWr);
    }
}


import {ActionManager} from "../../doug/ActionManager.sol";

contract TPLActionManager {
    function create() public
    returns (address) {
        return new ActionManager();
    }
}



contract TPLComponentsOpenEndedFund {
    function create(address _nousManager, address _owner) public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](3);
        _addrs = new address[](3);

        _names[0] = "ActionManager";
        _addrs[0] = new ActionManager();

        _names[1] = "ActionDb";
        _addrs[1] = new ActionDb();

//        _names[2] = "ProjectPermissionDb";
//        _addrs[2] = new ProjectPermissionDb(_nousManager, _owner);
//
        _names[2] = "SnapshotDb";
        _addrs[2] = new SnapshotDb();
//
//        _names[4] = "WalletDb";
//        _addrs[4] = new WalletDb();

        return (_names, _addrs);
    }
}

contract TemplateCreateToken_O_E_F {
    function create(address _nousToken, string _name, string _symbol, uint8 _decimals) public
    returns (bytes32[] _names, address[] _addrs) {
        _names = new bytes32[](2);
        _addrs = new address[](2);

        _names[0] = "OpenEndedSaleDb";
        _addrs[0] = new OpenEndedSaleDb();

        _names[1] = "OpenEndedToken";
        _addrs[1] = new OpenEndedToken(_nousToken, _name, _symbol, _decimals);

        return (_names, _addrs);
    }
}
