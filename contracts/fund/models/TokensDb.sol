pragma solidity 0.4.18;


import "../base/FundManagerEnabled.sol";
import "../../base/Construct.sol";


contract TokensDb is FundManagerEnabled, Construct {

    struct Token {
        string tokenSymbol;
        uint256 index;
    }

    mapping (address => Token) tokens;

    address[] private tokenIndex;

    // validate if wallet exists
    function isToken(address tokenAddress) public returns (bool) {
        if (tokenIndex.length == 0) return false;
        return tokenIndex[tokens[tokenAddress].index] == tokenAddress; // address is exists
    }

    function addToken(address tokenAddress, string tokenSymbol) public {
        require(isFundManager());
        require(isToken(tokenAddress));

        Token memory newToken;
        newToken.tokenSymbol = tokenSymbol;
        newToken.index = tokenIndex.push(tokenAddress) - 1;
        wallets[walletAddress] = newWallet;
        return true;
    }


}
