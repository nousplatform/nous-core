pragma solidity ^0.4.18;


import "../base/FundManagerEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/Construct.sol";


contract WalletDb is FundManagerEnabled, Construct {

    struct Wallets {
        bytes32 typeWallet;
        bool confirmed;
    }

    mapping (address => Wallets) private wallets;

    address[] private walletsIndex;

    // validate if wallet exists
    function isWallet(address walletAddress) public returns (bool isIndeed) {
        if (walletsIndex.length == 0) return false;
        return walletsIndex[wallets[walletAddress].index] == walletAddress;
    }

    // Add new wallet
    function insertWallet(bytes32 _typeWallet, address walletAddress) public returns (bool)
    {
        if (!isFundManager() || isWallet(walletAddress)) return false;

        Wallets memory newWallet;
        newWallet.typeWallet = _typeWallet;
        newWallet.confirmed = false;
        newWallet.index = walletsIndex.push(walletAddress) - 1;
        wallets[walletAddress] = newWallet;
        return true;
    }

    // confirm wallet
    function confirmWallet(address walletAddress) public returns (bool) {
        if (!isFundManager() || !isWallet(walletAddress)) return false;
        wallets[walletAddress].confirmed = true;
        return true;
    }
}
