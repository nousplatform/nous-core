pragma solidity ^0.4.18;


import {AllowPurchases} from "../../../doug/ownership/AllowPurchases.sol";
import {SnapshotDbInterface as SnapshotDb} from "../../commonFunctions/models/SnapshotDb.sol";
import {OpenEndedSaleDbInterface as OpenEndedSaleDb} from "../models/OpenEndedSaleDb.sol";


contract BaseSaleOpenEnded is AllowPurchases {

    address wallet;

    constructor(address _wallet) {
        wallet = _wallet;
    }

    function getRate() public view returns (uint) {
        SnapshotDb _snapshotDb = SnapshotDb(getContractAddress("SnapshotDb"));
        uint _rate = _snapshotDb.rate();
        if (_rate == 0) {
            _rate = getDataParamsSaleDb("initPrice");
        }
        require(_rate > 0);
        return _rate;
    }

    function getDataParamsSaleDb(bytes32 _rowName) public view returns(uint256) {
        uint _value = OpenEndedSaleDb(getContractAddress("OpenEndedSaleDb")).params(_rowName);
        require(_value > 0);
        return _value;
    }

}
