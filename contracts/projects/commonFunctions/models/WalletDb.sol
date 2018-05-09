pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


//TODO уточнить за снепшоты
contract WalletDb is Validee {

    /*struct Snapshot {
        uint256 totalUSD;
        uint256 course;
    }*/

    // snapshot - timestamp => value
    struct Wallets {
        bool confirmed;
        //mapping(uint256 => Snapshot) snapshot;
        uint256[] timestampSnapshot;
        uint256 index;
    }

    //symbol coins => structWallet
    mapping (bytes32 => Wallets) private wallets;

    address[] walletsIndex;

    // validate if wallet exists
    function isWallet(address walletAddress) public returns (bool) {
        if (walletsIndex.length == 0) return false;
        return walletsIndex[wallets[walletAddress].index] == walletAddress;
    }

    // Add new wallet
    function addWallet(bytes32 _typeWallet, address walletAddress) external returns (bool) {
        if (!validate()) return false;
        if (isWallet(walletAddress)) return false;

        Wallets memory newWallet;
        newWallet.typeWallet = _typeWallet;
        newWallet.confirmed = false;
        newWallet.index = walletsIndex.push(walletAddress) - 1;
        wallets[walletAddress] = newWallet;
        return true;
    }

    // confirm wallet
    function confirmWallet(address walletAddress) external returns (bool) {
        if (!validate()) return false;
        if (!isWallet(walletAddress)) return false;
        wallets[walletAddress].confirmed = true;
        return true;
    }

    /*function addSnapshot(bytes32 _wallet, uint256 _timestamp, uint256 ) {

    }*/

    function getWallets() externel constant returns() {
        for (uint256 i = 0; i < walletsIndex.length; i++) {

        }
    }
}
