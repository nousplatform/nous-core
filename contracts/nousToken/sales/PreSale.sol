pragma solidity ^0.4.4;

import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import "../crowdsale/BonusCrowdsale.sol";
import "../NousToken.sol";


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
contract PreSale is CappedCrowdsale, RefundableCrowdsale, BonusCrowdsale {

	function PreSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
		CappedCrowdsale(_cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(_goal)
		Crowdsale(_startTime, _endTime, _rate, _wallet)
		BonusCrowdsale()
	{
		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(_goal <= _cap);
	}

	function createTokenContract() internal returns (MintableToken) {
		return new NousToken();
	}
}

