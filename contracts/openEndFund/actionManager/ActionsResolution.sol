pragma solidity ^0.4.18;


import {LockedActionManager} from "./LockedActionManager.sol";
import {SnapshotDb} from "../models/SnapshotDb.sol";
import {WalletDbInterface as WalletDb} from "../models/WalletDb.sol";
import {OpenEndedSaleDbInterface as OpenEndedSaleDb} from "../models/OpenEndedSaleDb.sol";
import {DougEnabled} from "../../doug/safety/DougEnabled.sol";


contract ActionsResolution is DougEnabled, LockedActionManager {

    /**
    * @notice Action Add Wallet
    */
    function actionAddWallet(
        bytes32 _symbolWallet,
        bytes32 _addressWallet
    )
    isLocked
    orRole(ROLE_FUND_OWNER, ROLE_FUND_MANAGER)
    external
    {
        require(_symbolWallet != bytes32(0));
        require(_addressWallet != bytes32(0));

        address _wdb = getContractAddress("WalletDb");
        require(WalletDb(_wdb).addWallet(_symbolWallet, _addressWallet), "Error added wallet");
    }

    /**
    * @notice Wallet can only confirm the Nousplatform
    * @param _symbolWallet symbol
    * @param _addressWallet wallet address
    */
    function actionConfirmWallet(
        bytes32 _symbolWallet,
        bytes32 _addressWallet
    )
    isLocked
    onlyRole(ROLE_NOUS_PLATFORM)
    external
    {
        require(_symbolWallet != bytes32(0));
        require(_addressWallet != bytes32(0));

        address _wdb = getContractAddress("WalletDb");
        require(WalletDb(_wdb).confirmWallet(_symbolWallet, _addressWallet));
    }

    /**
    * @notice Add Snapshot can only confirm the Nousplatform
    * @param _timestamp a
    * @param _hash a
    * @param _rate a
    */
    function actionAddSnapshot(
        uint256 _timestamp,
        uint256 _hash,
        uint256 _rate
    )
    isLocked
    onlyRole(ROLE_NOUS_PLATFORM)
    external
    returns (bool)
    {
        address _sdb = getContractAddress("SnapshotDb");
        return SnapshotDb(_sdb).addSnapshot(_timestamp, _hash, _rate);
    }

    /* Sale Actions */
    function actionSetEntryFee(uint _entryFee)
    isLocked
    orRole(ROLE_FUND_OWNER, ROLE_FUND_MANAGER)
    external
    {
        require(_entryFee > 0);
        address _sdb = getContractAddress("OpenEndedSaleDb");
        OpenEndedSaleDb(_sdb).setEntryFee(_entryFee);
    }

    function actionSetExitFee(uint _exitFee)
    external
    isLocked
    orRole(ROLE_FUND_OWNER, ROLE_FUND_MANAGER)
    {
        require(_exitFee > 0);
        address _sdb = getContractAddress("OpenEndedSaleDb");
        OpenEndedSaleDb(_sdb).setExitFee(_exitFee);
    }

    function actionSetPlatformFee(uint _platformFee)
    external
    isLocked
    onlyRole(ROLE_NOUS_PLATFORM)
    {
        require(_platformFee > 0);
        address _sdb = getContractAddress("OpenEndedSaleDb");
        OpenEndedSaleDb(_sdb).setPlatformFee(_platformFee);
    }


}
