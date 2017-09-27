pragma solidity ^0.4.4;

import "../../../node_modules/zeppelin-solidity/contracts/token/ERC20.sol";
import "../../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol";
import "../../../node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "./Bonus.sol";
import "./NousToken.sol";

/**
 * @title SampleCrowdsale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract NousCrowdsale is CappedCrowdsale, Bonus, RefundableCrowdsale {

	uint256 restrictedPercent;

	address restricted;

	function NousCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, uint256 _restrictedPercent, address _restricted)
		CappedCrowdsale(_cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(_goal)
		Crowdsale(_startTime, _endTime, _rate, _wallet)
		Bonus()
	{
		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(_goal <= _cap);

		// bounty restricted
		restrictedPercent = _restrictedPercent;
		restricted = _restricted;
	}

	function createTokenContract() internal returns (MintableToken) {
		return new NousToken();
	}


	function finishMinting() public onlyOwner {
		uint issuedTokenSupply = token.totalSupply();
		uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
		token.mint(restricted, restrictedTokens);
		token.finishMinting();
	}

}
