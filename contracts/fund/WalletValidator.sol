pragma solidity ^0.4.4;


contract WalletValidator {

    address[] verifiedWallets;

    function() payable external {
        require(msg.value > 0);
        require(msg.sender != 0x0);
        verifiedWallets.push(msg.sender);
        msg.sender.transfer(msg.value);
    }

    function getVerifiedWallets(uint256 index) public constant returns(address[], uint256) {
        address[] memory verAddr;
        uint256 b = 0;
        uint256 differenceIndex = verifiedWallets.length - index;
        if (differenceIndex > 0) {
            verAddr = new address[](differenceIndex);
            for (uint256 i=index; i < verifiedWallets.length; i++) {
                verAddr[b++] = verifiedWallets[i];
            }
        }
        return (verAddr, verifiedWallets.length);
    }
}
