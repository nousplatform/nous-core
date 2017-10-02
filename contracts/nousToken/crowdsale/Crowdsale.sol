pragma solidity ^0.4.11;

import '../token/MintableToken.sol';
import '../math/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
	using SafeMath for uint256;

	// The token being sold
	MintableToken public token;

	// start and end timestamps where investments are allowed (both inclusive)
	uint256 public startTime;
	uint256 public endTime;
	uint256 public period;

	// address where funds are collected
	address public wallet;

	// how many token units a buyer gets per wei
	uint256 public rate;

	// amount of raised money in wei
	uint256 public weiRaised;
	
	uint256 public timeNow;

	/**
	* event for token purchase logging
	* @param purchaser who paid for the tokens
	* @param beneficiary who got the tokens
	* @param value weis paid for purchase
	* @param amount amount of tokens purchased
	*/
	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

	function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _period) {
		// todo uncomment
		//require(_startTime >= now);

		//require(_endTime >= _startTime);


		require(_period > 0);
		require(_rate > 0);
		require(_wallet != 0x0);

		token = createTokenContract();
		startTime = _startTime;
		endTime = _endTime;
		rate = _rate;
		wallet = _wallet;
		period = _period;
	}

	// creates the token to be sold.
	// override this method to have crowdsale of a specific mintable token.
	function createTokenContract() internal returns (MintableToken) {
		return new MintableToken();
	}


	// fallback function can be used to buy tokens
	function () payable {
		buyTokens(msg.sender);
	}

	// low level token purchase function
	function buyTokens(address beneficiary) public payable {
		require(beneficiary != 0x0);
		require(validPurchase());

		uint256 weiAmount = msg.value;

		// calculate token amount to be created
		uint256 tokens = weiAmount.mul(rate).div(1 ether);

		// add filter for calculate bonus
		uint256 addFilterBonus = additionalFilterBuyTokens(tokens);

		tokens = tokens.add(addFilterBonus);

		// update state
		weiRaised = weiRaised.add(weiAmount);

		token.mint(beneficiary, tokens);
		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

		forwardFunds();
	}

	// override if add bonus or else
	function additionalFilterBuyTokens(uint256 tokens) internal returns (uint256) {
		return 0;
	}

	// send ether to the fund collection wallet
	// override to create custom fund forwarding mechanisms
	function forwardFunds() internal {
		wallet.transfer(msg.value);
	}

	// @return true if the transaction can buy tokens
	function validPurchase() internal constant returns (bool) {
		//bool withinPeriod = now >= startTime && now <= endTime;
		timeNow = now;
		bool withinPeriod = now >= startTime && now <= startTime.add(period);
		bool nonZeroPurchase = msg.value != 0;
		return withinPeriod && nonZeroPurchase;
	}

	// @return true if crowdsale event has ended
	function hasEnded() public constant returns (bool) {
		return now > endTime;
	}


}
