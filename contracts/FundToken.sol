pragma solidity 0.4.18;


import "./token/StandardToken.sol";


/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract FundToken is StandardToken {
    string public name;
    string public symbol;
    uint8 public constant DECIMALS = 18;
    address public owner;

    uint256 public initialSupply;

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
    function FundToken(address _owner, string _name, string _symbol, uint256 _initialSupply) public {
        owner = _owner;
        name = _name;
        symbol = _symbol;

        initialSupply = _initialSupply * (10 ** uint256(DECIMALS));
        balances[msg.sender] = initialSupply;
    }

}
