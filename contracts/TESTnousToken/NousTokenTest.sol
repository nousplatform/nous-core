pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol"; //


contract TokenRecipient {
    function receiveApproval(address _from, uint _value) public;
}


contract NousTokenTest is MintableToken {

    string public name = "NousTkn";
    string public symbol = "NSU";
    uint8 public decimals = 18;

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
