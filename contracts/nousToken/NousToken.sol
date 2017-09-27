pragma solidity ^0.4.11;

import "./token/MintableToken.sol";

/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract NousToken is MintableToken {

	string public constant name = "Nous token";
	string public constant symbol = "NOUS";
  	uint32 public constant decimals = 18;

}
