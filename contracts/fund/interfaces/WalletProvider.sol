pragma solidity ^0.4.4;


contract WalletProvider {

    function insertWallet(bytes32 type_wallet, address walletAddress) returns (bool);

    function confirmWallet(address walletAddress) returns (bool);

    function addSnapshot(address walletAddress, uint balance) returns (bool);

}
