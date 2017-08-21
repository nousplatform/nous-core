pragma solidity ^0.4.4;

import "../interfaces/ContractProvider.sol";
import "../models/WalletsDb.sol";
import "../security/FundManagerEnabled.sol";

contract Wallets is FundManagerEnabled {

    function Wallets(){
        super.setDougAddress(msg.sender);
    }

    function addWallet(bytes32 type_wallet, address walletAddress) returns (bool){
        if (!isFundManager()){
            return false;
        }
        address walletsdb = ContractProvider(DOUG).contracts("walletsdb");

        if ( walletsdb == 0x0 ) {
            return false;
        }
        return  WalletsDb(walletsdb).insertWallet(type_wallet, walletAddress);
    }

    function confirmWallet(address walletAddress) returns (bool){
        if (!isFundManager()){
            return false;
        }
        address walletsdb = ContractProvider(DOUG).contracts("walletsdb");

        if ( walletsdb == 0x0 ) {
            return false;
        }
        return  WalletsDb(walletsdb).confirmWallet(walletAddress);
    }
}