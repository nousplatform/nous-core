pragma solidity ^0.4.18;

//import '../nous/ERC20.sol';

contract Investor {

	address owner;
	address nousToken;

	address[] investedFunds;

	function Investor(address account) {
		owner = account;
		//todo address nous token address
		//nousToken = '';
	}

	function setNousTokenAddress(address nstAddr){

	}

	function buyTokens(){

	}

	//
	function givePermissionForTranslationAmount(address fundAddress, uint amount){

	}


}
