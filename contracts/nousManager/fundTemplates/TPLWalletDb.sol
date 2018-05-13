pragma solidity ^0.4.18;


import {WalletDb} from "../../projects/commonFunctions/models/WalletDb.sol";
contract TPLWalletDb {
    function create() public returns (address) {
        return new WalletDb();
    }
}

