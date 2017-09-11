pragma solidity ^0.4.4;

import "../interfaces/ContractProvider.sol";
import "../models/WalletDb.sol";
import "../security/FundManagerEnabled.sol";
import "../interfaces/Constructor.sol";

contract Wallets is FundManagerEnabled, Constructor {

    function Wallets(){
        //super.setDougAddress(msg.sender);
    }

    function addWallet(bytes32 type_wallet, address walletAddress) returns (bool){
        if (!isFundManager()){
            return false;
        }
        address walletsdb = ContractProvider(DOUG).contracts("walletsdb");

        if ( walletsdb == 0x0 ) {
            return false;
        }
        return  WalletDb(walletsdb).insertWallet(type_wallet, walletAddress);
    }

    function confirmWallet(address walletAddress) returns (bool){
        if (!isFundManager()){
            return false;
        }
        address walletsdb = ContractProvider(DOUG).contracts("walletsdb");

        if ( walletsdb == 0x0 ) {
            return false;
        }
        return  WalletDb(walletsdb).confirmWallet(walletAddress);
    }

    function createSnapshot(address walletAddress, uint32 balance) returns (bool){
		if (!isFundManager()){
			return false;
		}

		address walletsdb = ContractProvider(DOUG).contracts("walletsdb");
		if ( walletsdb == 0x0 ) {
			return false;
		}

		return  WalletDb(walletsdb).addSnapshot(walletAddress, balance);
    }


}