pragma solidity ^0.4.18;


import {OpenEndedSaleDb} from "../../projects/openEndedFund/models/OpenEndedSaleDb.sol";
contract TPLOpenEndedSaleDb {
    function create(bytes32[] _paramSale, uint256[] _valSale) public returns (address) {
        return new OpenEndedSaleDb(_paramSale, _valSale);
    }
}
