pragma solidity ^0.4.18;


import "../base/FundManagerEnabled.sol";
import "../interfaces/ContractProvider.sol";


contract WalletDb is FundManagerEnabled {

    struct Wallets {
        bytes32 typeWallet;
        bool confirmed;
        uint256 index;
    }

    mapping (address => Wallets) private wallets;

    address[] private walletsIndex;

    // validate if wallet exists
    function isWallet(address walletAddress) public returns (bool) {
        if (walletsIndex.length == 0) return false;
        return walletsIndex[wallets[walletAddress].index] == walletAddress;
    }

    // Add new wallet
    function addWallet(bytes32 _typeWallet, address walletAddress) isFundManager public returns (bool) {
        if (isWallet(walletAddress)) return false;

        Wallets memory newWallet;
        newWallet.typeWallet = _typeWallet;
        newWallet.confirmed = false;
        newWallet.index = walletsIndex.push(walletAddress) - 1;
        wallets[walletAddress] = newWallet;
        return true;
    }

    // confirm wallet
    function confirmWallet(address walletAddress) isFundManager public returns (bool) {
        if (!isWallet(walletAddress)) return false;
        wallets[walletAddress].confirmed = true;
        return true;
    }
}
