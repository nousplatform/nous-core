pragma solidity ^0.4.4;

contract Logs{

	struct Log{
		address caller;
		bytes32 action;
		uint blockIndex;
		bool success;
	}

	bool LOGGING = true;
	uint public nextEntry = 0;
	mapping(uint => Log) public logEntries;

	modifier onlyinternal(){
		if(msg.sender != address(this)){
         	throw;
        }
    	_;
	}

	function save_log(bytes32 name,bool state){
		_log(name, state);
	}

	function _log(bytes32 actionName, bool success) internal {
		// TODO check if this is really necessary in an internal function.

		Log le = logEntries[nextEntry++];
		le.caller = msg.sender;
		le.action = actionName;
		le.success = success;
		le.blockIndex = block.number;
  	}
}