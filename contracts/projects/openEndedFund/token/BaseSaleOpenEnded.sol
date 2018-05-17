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
        var (_rate, ) = SnapshotDb(getContractAddress("SnapshotDb")).rate(0);
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
