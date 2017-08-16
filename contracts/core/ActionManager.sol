pragma solidity ^0.4.4;

import "./security/DougEnabled.sol";
import "./interfaces/ContractProvider.sol";
import "./models/ActionDB.sol";
import "./Permissions.sol";

contract ActionManager is DougEnabled {

	address activeAction;
  	address actionAddress = 0x0;
  	address actionDb = 0x0;

	uint8 permToLock = 255; // Current max.
	bool locked;

	function ActionManager(){
		permToLock = 255;
	}

	modifier check_actionDb(bytes32 actionName){
		actionDb = ContractProvider(DOUG).contracts("actiondb");
		if(actionDb == 0x0){
			Logs(DOUG).save_log(actionName, false);
			throw;
		}
		_;
	}

  	modifier checkAction(bytes32 actionName){
  		actionAddress = ActionDb(actionDb).actions(actionName);
  		if(actionAddress == 0x0){
  			Logs(DOUG).save_log(actionName, false);
  			throw;
  		}
  		_;
  	}

  	modifier permissions(){
  		address pAddr = ContractProvider(DOUG).contracts("perms");
		// Only check permissions if there is a permissions contract.
		if(pAddr != 0x0){
			Permissions p = Permissions(pAddr);

			// First we check the permissions of the account that's trying to execute the action.
			uint8 perm = p.perms(msg.sender);

			// Now we check that the action manager isn't locked down. In that case, special
			// permissions is needed.
			if(locked && perm < permToLock){
				Logs(DOUG).save_log(actionName, false);
				throw;
			}

			// Now we check the permission that is required to execute the action.
			uint8 permReq = Action(actn).permission();

			// Very simple system.
			if (perm < permReq){
				Logs(DOUG).save_log(actionName, false);
				throw;
			}
		}
		_;
  	}

  	function ActionAddAction(bytes32 actionName, bytes32 name, address addr) check_actionDb (actionName)
	checkAction(actionName) permissions() returns (bool) {
		activeAction = actionAddress;
		bool memory res = ActionAddAction(actionAddress).execute(name, addr);
		activeAction = 0x0;
		return res;
	}

	/*function lock() returns (bool) {
		if(msg.sender != activeAction){
			return false;
		}
		if(locked){
			return false;
		}
		locked = true;
	}

	function unlock() returns (bool) {
		if(msg.sender != activeAction){
			return false;
		}
		if(!locked){
			return false;
		}
		locked = false;
	}*/

	// Validate can be called by a contract like the bank to check if the
	// contract calling it has permissions to do so.
	function validate(address addr) constant returns (bool) {
		return addr == activeAction;
	}

}
