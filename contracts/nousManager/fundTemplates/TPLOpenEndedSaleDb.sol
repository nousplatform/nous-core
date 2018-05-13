pragma solidity ^0.4.18;


import {OpenEndedSaleDb} from "../../projects/openEndedFund/models/OpenEndedSaleDb.sol";
contract TPLOpenEndedSaleDb {
    function create() public returns (address) {
        return new OpenEndedSaleDb();
    }
}
