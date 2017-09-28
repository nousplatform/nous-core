pragma solidity ^0.4.4;

import "../crowdsale/CappedCrowdsale.sol";
import "../crowdsale/RefundableCrowdsale.sol";
import './Crowdsale.sol';

contract BonusCrowdsale is Crowdsale {

	struct BonusStruct {
		uint256 amountFrom;
		uint256 amountTo;
		uint256 percentBonus;
		uint256 countComplete;
	}

	BonusStruct[] bonuses;

	// bonuses is accrued
	uint256 public accruedBonuses;

	// inicialize bonuses
	function BonusCrowdsale(){
		accruedBonuses = 0;
		bonuses.push(BonusStruct(0, 100000, 15, 0));
    	bonuses.push(BonusStruct(100000, 200000, 10, 0));
	}

	// additional filter for add bonus
	// @returns bonus
	function additionalFilterBuyTokens(uint256 tokens) internal returns (uint256){
		uint256 bonus = 0;
		uint256 totalSupply = token.totalSupply();
		for (uint256 i; i < bonuses.length; i++){
			if (totalSupply > bonuses[i].amountFrom && totalSupply <= bonuses[i].amountTo){
				bonus = tokens.mul(bonuses[i].percentBonus).div(100);
				accruedBonuses = accruedBonuses.add(bonus);
			}
		}
		return bonus;
	}

}
