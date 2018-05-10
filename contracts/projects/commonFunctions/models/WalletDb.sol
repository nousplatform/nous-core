pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


//TODO уточнить за снепшоты
contract WalletDb is Validee {

    /*struct Snapshot {
        uint256 totalUSD;
        uint256 course;
    }*/

    // snapshot - timestamp => value
    struct Wallet {
        bytes32 addr;
        bool confirmed;
        uint256 index;
        //mapping(uint256 => Snapshot) snapshot;
        //uint256[] timestampSnapshot;
    }

    //symbol coins => structWallet
    mapping (bytes32 => Wallet) wallets;

    bytes32[] public walletsIndex;

    // validate if wallet exists
    function isWallet(bytes32 _wallet) public returns (bool) {
        if (walletsIndex.length == 0) return false;
        return walletsIndex[wallets[_wallet].index] == _wallet;
    }

    // Add new wallet
    function addWallet(bytes32 _typeWallet, bytes32 _walletAddress) external returns (bool) {
        if (!validate()) return false;
        if (isWallet(walletAddress)) return false;

        wallets[_typeWallet].addr = _walletAddress;
        wallets[_typeWallet].index = walletsIndex.push(_typeWallet) - 1;
        return true;
    }

    // confirm wallet
    function confirmWallet(bytes32 _wallet) external returns (bool) {
        if (!validate()) return false;
        if (!isWallet(_wallet)) return false;
        wallets[_wallet].confirmed = true;
        return true;
    }

    function count() external constant returns(uint256) {
        return walletsIndex.length;
    }

    function getWalletByIndex(uint256 _index) external constant returns(bytes32 wallet, bytes32 walletAddress, bool confirmed) {
        Wallet memory _wallet = wallets[walletsIndex[_index]];
        return (walletIndex[_index], _wallet.addr, _wallet.confirmed);
    }
}
