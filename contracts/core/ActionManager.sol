pragma solidity ^0.4.4;

import "./security/DougEnabled.sol";
import "./interfaces/ContractProvider.sol";

contract ActionManager is DougEnabled {

	struct ActionLogEntry {
		address caller;
		bytes32 action;
		uint blockNumber;
		bool success;
	}

	uint8 permToLock = 255; // Current max.
	bool locked;

	bool LOGGING = true;

	// Adding a logger here, and not in a separate contract. This is wrong.
	// Will replace with array once that's confirmed to work with structs etc.
	uint public nextEntry = 0;
	mapping(uint => ActionLogEntry) public logEntries;

	function ActionManager(){

	}

	function test() constant returns (address) {
		return DOUG;
	}

	function execute(bytes32 actionName, bytes data) returns (bool) {
		address actionDb = ContractProvider(DOUG).contracts("actiondb");

		if (actionDb == 0x0){
			_log(actionName, false);
			return false;
		}

		return true;
	}

	function _log(bytes32 actionName, bool success) internal {
		// TODO check if this is really necessary in an internal function.

		if(!LOGGING || msg.sender != address(this)){
			return;
		}

		ActionLogEntry le = logEntries[nextEntry++];
		le.caller = msg.sender;
		le.action = actionName;
		le.success = success;
		le.blockNumber = block.number;
	}

}
