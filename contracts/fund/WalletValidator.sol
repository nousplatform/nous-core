pragma solidity ^0.4.4;


contract WalletValidator {

    mapping(address => bool) public userWallets;

    function() payable external {
        require(msg.value > 0);
        require(msg.sender != 0x0);

        userWallets[msg.sender] = true;
        msg.sender.transfer(msg.value);
    }

    function validate(address walletAddress) public constant returns(bool) {
        require(walletAddress != 0x0);
        return userWallets[walletAddress];
    }
    
    function validateList(address[] walletsAddresses) public returns(bool[] memory res) {
        uint256 length = walletsAddresses.length;
        require(length > 0);
        res = new bool[](length);
        for (uint256 i = 0; i < length; i++) {
            res[i] = validate(walletsAddresses[i]);
        }
        return res;
    }
    
    
}
