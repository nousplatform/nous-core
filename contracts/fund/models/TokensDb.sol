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
    function isToken(address _tokenAddress) public returns (bool) {
        if (tokenIndex.length == 0) return false;
        return tokenIndex[tokens[_tokenAddress].index] == _tokenAddress; // address is exists
    }

    function addToken(address _tokenAddress, string _tokenSymbol) isFundManager public returns(bool) {
        require(!isToken(_tokenAddress));

        Token token = tokens[_tokenAddress];
        token.tokenSymbol = _tokenSymbol;
        token.index = tokenIndex.push(_tokenAddress) - 1;
        return true;
    }


}
