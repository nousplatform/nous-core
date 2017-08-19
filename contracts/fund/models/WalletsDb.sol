pragma solidity ^0.4.4;

contract WalletsDB {

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

    }

    function addWallet(
        bytes32 type_wallet,
        address walletAddress
    )

    {
        wallets[walletAddress].type_wallet = type_wallet;
        wallets[walletAddress].confirmed = false;
        wallets[walletAddress].index = walletsIndex.push(walletAddress) - 1;
    }
}
