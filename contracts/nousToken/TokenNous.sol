pragma solidity ^0.4.4;


import "./token/MintableToken.sol";
import "./ownership/Ownable.sol";


contract TokenNous is MintableToken {

    string public constant name = "Simple Coint Token";

    string public constant symbol = "SCT";

    uint32 public constant decimals = 18;

}


contract Crowdsale is Ownable {

    using SafeMath for uint;

	// A special account managed by trustees to increase investor confidence
    address multisig;

	// percentage of tokens bounty
    uint restrictedPercent;

	// address bounty
    address restricted;

    TokenNous public token = new TokenNous();

	// start ico
    uint start;

	// period days
    uint period;

	// limit of the amount to be collected
    uint hardcap;

	// the conversion factor of the ether into our tokens
    uint rate;

    function Crowdsale() {
		multisig = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
		restricted = 0xb3eD172CC64839FB0C0Aa06aa129f402e994e7De;
		restrictedPercent = 40;
		rate = 100000000000000000000;
		start = 1500379200;
		period = 28;
        hardcap = 10000000000000000000000;
    }

    modifier saleIsOn() {
    	require(now > start && now < start + period * 1 days);
    	_;
    }

    modifier isUnderHardCap() {
        require(multisig.balance <= hardcap);
        _;
    }

    function finishMinting() public onlyOwner {
		uint issuedTokenSupply = token.totalSupply();
		uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
		token.mint(restricted, restrictedTokens);
        token.finishMinting();
    }

   function createTokens() isUnderHardCap saleIsOn payable {
        multisig.transfer(msg.value);
        uint tokens = rate.mul(msg.value).div(1 ether);
        uint bonusTokens = 0;

        tokens += bonusTokens;
        token.mint(msg.sender, tokens);
    }

    function() external payable {
        createTokens();
    }

}