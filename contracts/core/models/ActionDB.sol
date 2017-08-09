pragma solidity ^0.4.4;

import "../security/ActionManagerEnabled.sol";
import "../security/DougEnabled.sol";

contract ActionDB is ActionManagerEnabled {

	// This is where we keep all the actions.
  mapping (bytes32 => address) public actions;

	/*function ActionDB(){

	}*/

	//TODO test
	function testValidateDoug() constant returns (address){
			return DOUG;
	}

	// To make sure we have an add action action, we need to auto generate
	// it as soon as we got the DOUG address.
	function setDougAddress(address dougAddr) returns (bool result) {

		if (!super.setDougAddress(dougAddr)){
			return false;
		}
		return true;

		/*var addaction = new ActionAddAction();

		// If this fails, then something is wrong with the add action contract.
		// Will be events logging these things in later parts.
		if(!DougEnabled(addaction).setDougAddress(dougAddr)){
			return false;
		}

		actions["addaction"] = address(addaction);*/
	}

}
