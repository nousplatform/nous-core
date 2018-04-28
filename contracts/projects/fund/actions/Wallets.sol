pragma solidity ^0.4.18;


import "./Permission.sol";
import "../interfaces/WalletProvider.sol";


contract Wallets is Permission {

    // Wallet actions
    //@dev add wallet address
    function addWallet(bytes32 _typeWallet, address _walletAddress) external returns (bool) {
        require(checkPermission("owner") || checkPermission("manager"));
        require(_typeWallet.length > 0);
        require(_walletAddress != 0x0);

        address walletdb = getContractAddress("wallet_db");
        return  WalletProvider(walletdb).insertWallet(_typeWallet, _walletAddress);
    }

    //@dev Confirmed Wallet
    //@dev Only nous platform will be confirm
    function confirmedWallet(address _walletAddress) external returns (bool) {
        require(checkPermission("nous"));
        require(_walletAddress != 0x0);

        address walletDb = getContractAddress("wallet_db");
        return  WalletProvider(walletDb).confirmWallet(_walletAddress);
    }

}
