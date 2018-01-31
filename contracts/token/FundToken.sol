pragma solidity ^0.4.18;


import "./StandardToken.sol";


/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract FundToken is StandardToken {

  string public name;
  string public symbol;
  uint256 public rate;
  uint8 public constant decimals = 18;

  uint256 public INITIAL_SUPPLY;

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function FundToken(string _name, string _symbol, uint256 _initialSupply , uint256 _rate) public {
    name = _name;
    symbol = _symbol;
    rate = _rate;

    totalSupply = _initialSupply * (10 ** uint256(decimals));
    balances[msg.sender] = totalSupply;
  }

}
