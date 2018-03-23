pragma solidity ^0.4.18;


contract TokensDb {

    struct Token {
        string tokenSymbol;
        uint256 index;
    }

    mapping (address => Token) tokens;

    address[] internal tokenIndex;

    // validate if wallet exists
    function isToken(address _tokenAddress) internal returns (bool) {
        if (tokenIndex.length == 0) return false;
        return tokenIndex[tokens[_tokenAddress].index] == _tokenAddress; // address is exists
    }

}
