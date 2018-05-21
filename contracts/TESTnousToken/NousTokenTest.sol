pragma solidity ^0.4.18;


import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
//import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";


contract TokenRecipient {
    function receiveApproval(address _from, uint _value) public;
}


contract NousTokenTest is MintableToken {

    string public name = "NousTkn";
    string public symbol = "NSU";
    uint8 public decimals = 18;

    uint256 EXPONENT = 10 ** uint256(decimals);

    function mint(address _to, uint256 _amount) public returns (bool) {
        _amount = _amount * EXPONENT;
        super.mint(_to, _amount);
    }

    /**
    * Set allowance for other address and notify
    *
    * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
    *
    * @param _spender The address authorized to spend
    * @param _value the max amount they can spend in EXPONENTS
    */
    function approveAndCall(address _spender, uint256 _value) public returns (bool) {
        TokenRecipient spender = TokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value);
            return true;
        }
    }

}
