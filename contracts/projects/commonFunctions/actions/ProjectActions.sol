pragma solidity ^0.4.18;


import {ActionAddActions, Action} from "../../../doug/actions/Mainactions.sol";
import {Validee} from "../../../doug/safety/Validee.sol";
import {WalletDbInterface as WalletDb} from "../models/WalletDb.sol";
import {SnapshotDbInterface as SnapshotDb} from "../models/SnapshotDb.sol";


/**
* @notice LockedAction do not set permission
*/
contract LockedAction is Validee {

    //permission lvl
    bool public locked = false;

    modifier allowExecute() {
        require(!locked);
        _;
    }

    function lockAction() external returns (bool) {
        require(validate());
        locked = true;
    }

    function unlockAction() external returns (bool) {
        require(validate());
        locked = false;
    }
}


// Add action. NOTE: Overwrites currently added actions with the same name.
contract ProjectActionAddActions is ActionAddActions, LockedAction {

    constructor() {
        permission["owner"] = false;
        permission["nous"] = true;
    }

    function execute(bytes32[] _names, address[] _addrs) public allowExecute {
        super.execute(_names, _addrs);
    }
}

contract ActionAddWallet is Action("owner") {

    function execute(bytes32 _typeWallet, bytes32 _walletAddress) external {
        require(isActionManager(), "Access denied");
        address _wdb = getContractAddress("WalletDb");
        require(WalletDb(_wdb).addWallet(_typeWallet, _walletAddress));
    }
}

contract ActionConfirmWallet is Action("nous") {

    bool allowSetPermission = false;

    function execute(bytes32 _wallet) external {
        require(isActionManager(), "Access denied");
        address _wdb = getContractAddress("WalletDb");
        require(WalletDb(_wdb).confirmWallet(_wallet));
    }
}

contract ActionAddSnapshot is Action("nous") {

    bool allowSetPermission = false;

    function execute(uint256 _timestamp, bytes32 _hash, uint256 _rate) external {
        require(isActionManager(), "Access denied");
        address _sdb = getContractAddress("WalletDb");
        require(SnapshotDb(_sdb).addSnapshot(_timestamp, _hash, _rate));
    }
}
