pragma solidity ^0.4.4;


import "../security/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";

contract WalletsDb is DougEnabled {

    struct Snapshot {
        int32 balance; // current balance
        uint timestamp; // time in snapshot
    }

    struct Wallets {
        bytes32 type_wallet;
        bool confirmed;
        uint index;
        mapping ( uint => Snapshot ) snapshot;
    }

    mapping ( address => Wallets ) private wallets;
    address[] private walletsIndex;

    function WalletsDB(){
        setDougAddress(msg.sender);
    }

    function isFromWallet() returns (bool){
        if(DOUG != 0x0 && msg.sender == ContractProvider(DOUG).contracts("wallets")){
            return true;
        }
        return false;
    }

    function isWallet(address walletAddress)
        public
        returns(bool isIndeed)
    {
        if (walletsIndex.length == 0 ) return false;
        return walletsIndex[wallets[walletAddress].index] == walletAddress;
    }

    function addWallet(
        bytes32 type_wallet,
        address walletAddress)
    {
        if (!isFromWallet() || !isWallet(walletAddress)) return false;

        Wallets memory newWallet;

        newWallet.type_wallet = type_wallet;
        newWallet.confirmed = false;
        newWallet.index = walletsIndex.push(walletAddress) - 1;


        wallets[walletAddress] = newWallet;

        return true;
    }

    function confirmWallet(address walletAddress){
        if (!isFromWallet() || !isWallet(walletAddress)) return false;
        wallets[walletAddress].confirmed = true;

        return true;
    }
}