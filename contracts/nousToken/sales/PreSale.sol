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
    
    uint256 startTime = 1506943200; // Thu, 28 Sep 2017 16:35:00 GMT
    uint256 endTime = 1506684000; //
    uint256 period = 86400; // 300 10 min
    uint256 rate = 6400; // 6400 NOUS => 1 ether => per wei;
    uint256 goal = 400000 * 1 ether; // min investment capital
    uint256 cap = 10000000 * 1 ether; // max capital in ether
    address wallet = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
    address nextSale;
    //address restricted = 0xb3eD172CC64839FB0C0Aa06aa129f402e994e7De;
    //uint256 restrictedPercent = 40; 

	function PreSale()
		CappedCrowdsale(cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(goal)
		Crowdsale(startTime, endTime, rate, wallet, period)
		BonusCrowdsale()
	{
		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(goal <= cap);
	}

	function createTokenContract() internal returns (MintableToken) {
		return new NousToken();
	}

	// finalize an add new sale.
	function finalize(address _nextSale) onlyOwner public {
		require(nextSale != 0x0);
		nextSale = _nextSale;
		super.finalize();
	}


	// pre sale finalization and chang owner in RefundVault and new sale
	function finalization() internal {
		require(nextSale != 0x0);
		token.transferOwnership(nextSale);
		vault.transferOwnership(nextSale);
	}
}

