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
    
    uint256 _startTime = 1506598500; // 27.09.2017 00:00:00
    uint256 _endTime = 1506598800; // 27.09.2017 00:00:00
    uint256 _rate = 100000000000000000000;
    uint256 _goal = 400000;
    uint256 _cap = 777000000;
    address _wallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
    //address restricted = 0xb3eD172CC64839FB0C0Aa06aa129f402e994e7De;
    //uint256 restrictedPercent = 40;

	function PreSale()
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

