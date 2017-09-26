pragma solidity ^0.4.4;

import "../../../node_modules/zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol";
import "../../../node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "../../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * Bonus contract
 */
contract Bonus is CappedCrowdsale, RefundableCrowdsale  {

	struct BonusStruct {uint256 amountFrom; uint256 amountTo;  uint256 percentBonus; uint256 countComplete;}

	BonusStruct[] bonuses;

	function Bonus(){
		bonuses.push(BonusStruct(0, 100000, 15, 0));
		bonuses.push(BonusStruct(100000, 200000, 10, 0));
	}

	function getBonuses(uint256 tokens) internal returns (uint256){
		uint256 totalSupply = token.totalSupply();
		for (uint256 i; i < bonuses.length; i++){

			if (totalSupply > bonuses[i].amountFrom && totalSupply > bonuses[i].amountTo){
				tokens = tokens.mul(bonuses[i].percentBonus);
			}
		}
		return tokens;
	}

	// low level token purchase function
	function buyTokens(address beneficiary) public payable {
		require(beneficiary != 0x0);
		require(validPurchase());

		uint256 weiAmount = msg.value;

		// calculate token amount to be created && bonuses
		uint256 tokens = getBonuses(weiAmount.mul(rate));

		// update state
		weiRaised = weiRaised.add(weiAmount);

		token.mint(beneficiary, tokens);
		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

		forwardFunds();
	}
}
