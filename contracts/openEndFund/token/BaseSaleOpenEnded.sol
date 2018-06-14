pragma solidity ^0.4.18;


import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import {SnapshotDbInterface as SnapshotDb} from "../models/SnapshotDb.sol";
import {OpenEndedSaleDbInterface as OpenEndedSaleDb} from "../models/OpenEndedSaleDb.sol";
import "../../lib/MathCalc.sol";
//import {Validee} from "../../doug/safety/Validee.sol";


contract BaseSaleOpenEnded is AllowPurchases {

    using SafeMath for uint256;

    address wallet;

    address nousWallet;

    string public name;

    string public symbol;

    uint8 public decimals;

    function rate()
    public
    view
    returns (uint)
    {
        uint _rate = SnapshotDb(getContractAddress("SnapshotDb")).rate();
        if (_rate == 0) {
            _rate = getDataParamsSaleDb("initPrice");
        }
        require(_rate > 0);
        return _rate;
    }

    function getDataParamsSaleDb(bytes32 _rowName)
    public
    view
    returns (uint256)
    {
        return OpenEndedSaleDb(getContractAddress("OpenEndedSaleDb")).params(_rowName);
    }

    function getFees(
        uint256 _totalAmount,
        bytes32 _firstFeeName,
        bytes32 _secondFeeName
    )
    internal
    view
    returns (uint256 _amountEntryFee, uint256 _amountPlatformFee)
    {
        _amountEntryFee = MathCalc.calculatePercent(_totalAmount, getDataParamsSaleDb(_firstFeeName), decimals);
        _amountPlatformFee = MathCalc.calculatePercent(_totalAmount, getDataParamsSaleDb(_secondFeeName), decimals);
    }

}
