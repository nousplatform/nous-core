pragma solidity ^0.4.18;


import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import {SnapshotDbInterface as SnapshotDb} from "../models/SnapshotDb.sol";
import {OpenEndedSaleDbInterface as OpenEndedSaleDb} from "../models/OpenEndedSaleDb.sol";


contract BaseSaleOpenEnded is AllowPurchases {

    struct SaleParam {
        uint256 entryFee;
        uint256 exitFee;
        uint256 initPrice;
        uint256 maxFundCup;
        uint256 maxInvestors;
        uint256 managementFee;
    }

    address wallet;

    constructor(address _wallet) {
        wallet = _wallet;
    }

    function rate() public view returns (uint) {
        address _sdb = getContractAddress("SnapshotDb");
        uint _rate = SnapshotDb(_sdb).rate();
        if (_rate == 0) {
            _rate = getDataParamsSaleDb("initPrice");
        }
        require(_rate > 0);
        return _rate;
    }

    function getDataParamsSaleDb(bytes32 _rowName) public view returns(uint256) {
        address _sdb = getContractAddress("OpenEndedSaleDb");
        return OpenEndedSaleDb(_sdb).params(_rowName);
    }

}
