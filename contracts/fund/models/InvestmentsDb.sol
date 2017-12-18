pragma solidity ^0.4.4;

import "../base/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../interfaces/Construct.sol";


contract AssetsDb  is DougEnabled, Construct {

	// investor contract address => share amount fund
 	mapping (address => uint) public balances;

	function deposit(address addr) returns (bool res) {
		if(DOUG != 0x0){
			address bank = ContractProvider(DOUG).contracts("bank");
			if (msg.sender == bank ){
				balances[addr] += msg.value;
				return true;
			}
		}
		// Return if deposit cannot be made.
		//msg.sender.send(msg.value);
		return false;
	}

	function withdraw(address addr, uint amount) returns (bool res) {
		if(DOUG != 0x0){
			address bank = ContractProvider(DOUG).contracts("bank");
			if (msg.sender == bank ){
				uint oldBalance = balances[addr];
				if(oldBalance >= amount){
					//msg.sender.send(amount);
					balances[addr] = oldBalance - amount;
					return true;
				}
			}
		}
		return false;
	}



}
