pragma solidity ^0.4.18;


contract ICODb {

    struct Token {
        address sale;
        bytes32 tokenSymbol;
        uint256 index;
    }

    mapping (address => Token) ico;

    address[] internal tokenIndex;

    // validate if wallet exists
    function isToken(address _tokenAddress) internal returns (bool) {
        if (tokenIndex.length == 0) return false;
        return tokenIndex[ico[_tokenAddress].index] == _tokenAddress; // address is exists
    }

}
