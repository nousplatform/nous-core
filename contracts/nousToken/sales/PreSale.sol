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
    
    uint256 startTime = 1506616500; // Thu, 28 Sep 2017 16:35:00 GMT
    uint256 endTime = 1506686400; // Fri, 29 Sep 2017 12:00:00 GMT
    uint256 rate = 6400;
    uint256 goal = 400000;
    uint256 cap = 777000000;
    address wallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
    //address restricted = 0xb3eD172CC64839FB0C0Aa06aa129f402e994e7De;
    //uint256 restrictedPercent = 40;

	function PreSale()
		CappedCrowdsale(cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(goal)
		Crowdsale(startTime, endTime, rate, wallet)
		BonusCrowdsale()
	{
		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(goal <= cap);
	}

	function createTokenContract() internal returns (MintableToken) {
		return new NousToken();
	}
}

