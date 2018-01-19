pragma solidity ^0.4.18;


contract WalletProvider {

    function insertWallet(bytes32 typeWallet, address walletAddress) public returns (bool);

    function confirmWallet(address walletAddress) public returns (bool);

}
