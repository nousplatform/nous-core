pragma solidity ^0.4.18;


contract TokensDb {

    struct Token {
        string tokenSymbol;
        uint256 index;
    }

    mapping (address => Token) tokens;

    address[] private tokenIndex;

    // validate if wallet exists
    function isToken(address _tokenAddress) public returns (bool) {
        if (tokenIndex.length == 0) return false;
        return tokenIndex[tokens[_tokenAddress].index] == _tokenAddress; // address is exists
    }

    function addToken(string _tokenSymbol, address _tokenAddress) public returns(bool) {
        require(_tokenAddress != 0x0);
        require(!isToken(_tokenAddress));

        Token memory token = tokens[_tokenAddress];
        token.tokenSymbol = _tokenSymbol;
        token.index = tokenIndex.push(_tokenAddress) - 1;
        return true;
    }
}
