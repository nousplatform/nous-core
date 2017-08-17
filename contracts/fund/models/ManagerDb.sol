pragma solidity ^0.4.4;

import "../security/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";

contract ManagerDb is DougEnabled {

	struct ManagerStruct {
		bytes32 firstname;
		bytes32 lastname;
		bytes32 email;
		uint index;
	}

	mapping ( address => ManagerStruct ) private ManagerStructs;
	address[] private managerIndex; // Managers

	function ManagerDb(){
		setDougAddress(msg.sender);
	}

	function isFromManager() returns (bool){
		if(DOUG != 0x0){
			address managC = ContractProvider(DOUG).contracts("managers");
			if (msg.sender == managC ){
				return true;
			}
			return false;
		} else {
			return false;
		}
	}

	function isManager(address managerAddress)
		public
		returns(bool isIndeed)
	{
		if (managerIndex.length == 0 ) return false;
		return managerIndex[ManagerStructs[managerAddress].index] == managerAddress;
	}

	function insertManager(
		address managerAddress,
		bytes32 firstName,
		bytes32 lastName,
		bytes32 email
	)
		returns (bool)
	{
		if (!isFromManager() || isManager(managerAddress)) return false;

		ManagerStruct memory newManager;
		newManager.firstname = firstName;
		newManager.lastname = lastName;
		newManager.email = email;
		newManager.index = managerIndex.push(managerAddress)-1;

		ManagerStructs[managerAddress] = newManager;
		return true;
	}

	function deleteManager(address managerAddress)
		returns(bool)
	{
		if (!isFromManager() || !isManager(managerAddress)) return false;

		uint rowToDelete = ManagerStructs[managerAddress].index; // index manager to de
		address keyToMove = managerIndex[managerIndex.length-1];
		managerIndex[rowToDelete] = keyToMove;
		ManagerStructs[keyToMove].index = rowToDelete;
		managerIndex.length--;

		return true;
	}


}
