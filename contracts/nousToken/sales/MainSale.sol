pragma solidity ^0.4.4;

import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import "../crowdsale/BonusCrowdsale.sol";
import "../NousToken.sol";
import "../token/MintableToken.sol";
import "../crowdsale/RefundVault.sol";


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
contract MainSale is CappedCrowdsale, RefundableCrowdsale, BonusCrowdsale {

	uint256 startTime = 1506943200; //
	uint256 endTime = 1506685200; //
	uint256 period = 86400; // 600 10 min
	uint256 rate = 6400; // 6400 NOUS => 1 ether => per wei;
	uint256 goal = 400000 * 1 ether; // min investment capital
	uint256 cap = 10000000 * 1 ether; // max capital in ether
	address wallet = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;
	address restricted = 0xb3eD172CC64839FB0C0Aa06aa129f402e994e7De;
	uint256 restrictedPercent = 40;
	address tokenAddress = 0x3cf84b2696bcf70cc87e30661a028d947465892a;
	address vaultAddress = 0x6842e3c05cfb01844b0a3a8024cd18cbe35aeb5f;


	function MainSale()
		CappedCrowdsale(cap)
		FinalizableCrowdsale()
		RefundableCrowdsale(goal)
		Crowdsale(startTime, endTime, rate, wallet, period)
		BonusCrowdsale()
	{

		//require(_token != 0x0);
		token = MintableToken(tokenAddress);

		vault = RefundVault(vaultAddress);

		//As goal needs to be met for a successful crowdsale
		//the value needs to less or equal than a cap which is limit for accepted funds
		require(goal <= cap);

	}

}
