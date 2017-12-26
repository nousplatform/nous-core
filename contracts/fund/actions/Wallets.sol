pragma solidity ^0.4.4;

import "./Managers.sol";
import "../interfaces/WalletProvider.sol";


contract Wallets is Managers {

    // Wallet actions
    //@dev add wallet address
    function addWallet(bytes32 type_wallet, address walletAddress) external returns (bool) {
        require(!checkPermission("owner") && !checkPermission("manager"));
        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).insertWallet(type_wallet, walletAddress);
    }

    //@dev Confirmed Wallet
    //@dev Only nous platform will be confirm
    function confirmedWallet(address walletAddress) external returns (bool) {
        require(!checkPermission("nous"));
        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).confirmWallet(walletAddress);
    }

    // Create snapshot can do only Nous platform
    function createSnapshot(address walletAddress, uint32 balance) external returns (bool) {
        require(!checkPermission("nous"));
        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).addSnapshot(walletAddress, balance);
    }
}
