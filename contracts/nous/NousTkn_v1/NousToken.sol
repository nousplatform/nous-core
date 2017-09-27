pragma solidity ^0.4.11;

import "../../../node_modules/zeppelin-solidity/contracts/token/MintableToken.sol";

/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract NousToken is MintableToken {

	string public constant name = "Nous token";

	string public constant symbol = "NOUS";

  	uint32 public constant decimals = 18;

  	address public saleAgent;

  	/**
	* @dev Function change owner
	* @param _newSaleAgent Address new sale agent contract
	*/
	function nextSaleAgent(address _newSaleAgent) onlyOwner {
		saleAgent = _newSaleAgent;
		transferOwnership(_newSaleAgent);
	}


}

