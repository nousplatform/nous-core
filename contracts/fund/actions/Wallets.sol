pragma solidity ^0.4.18;


import "./Managers.sol";
import "../interfaces/WalletProvider.sol";
import "../../lib/Validator.sol";


contract Wallets is Managers {

    // Wallet actions
    //@dev add wallet address
    function addWallet(bytes32 _typeWallet, address _walletAddress) external returns (bool) {
        require(!checkPermission("owner") && !checkPermission("manager"));
        require(_typeWallet.length > 0);
        require(_walletAddress != 0x0);

        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).insertWallet(_typeWallet, _walletAddress);
    }

    //@dev Confirmed Wallet
    //@dev Only nous platform will be confirm
    function confirmedWallet(address _walletAddress) external returns (bool) {
        require(!checkPermission("nous"));
        require(_walletAddress != 0x0);

        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).confirmWallet(_walletAddress);
    }

    // Create snapshot can do only Nous platform
    /*function createSnapshot(address _walletAddress, uint32 _balance) external returns (bool) {
        require(!checkPermission("nous"));
        require(_walletAddress != 0x0);

        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).addSnapshot(_walletAddress, _balance);
    }*/
}
