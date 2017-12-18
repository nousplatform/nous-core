pragma solidity ^0.4.4;


import "../interfaces/ContractProvider.sol";
import "../interfaces/Construct.sol";
import "../base/FundManagerEnabled.sol";


contract ManagerDb is FundManagerEnabled, Construct {

	struct ManagerStruct {
		bytes32 firstname;
		bytes32 lastname;
		bytes32 email;
		uint index;
	}

	mapping (address => ManagerStruct) Managers;
	address[] public managerIndex; // Managers

	function isManager(address managerAddress)
		public
		constant
		returns(bool isIndeed)
	{
		if (managerIndex.length == 0 ) return false;
		return managerIndex[Managers[managerAddress].index] == managerAddress;
	}

	function insertManager(
		address managerAddress,
		bytes32 firstName,
		bytes32 lastName,
		bytes32 email
	)
		returns (bool)
	{
		if (!isFundManager() || isManager(managerAddress)) return false;

		ManagerStruct memory newManager;
		newManager.firstname = firstName;
		newManager.lastname = lastName;
		newManager.email = email;
		newManager.index = managerIndex.push(managerAddress)-1;

		Managers[managerAddress] = newManager;
		return true;
	}

	function deleteManager(address managerAddress) returns(bool)
	{
		if (!isFundManager() || !isManager(managerAddress)) return false;

		uint rowToDelete = Managers[managerAddress].index; // index manager to de
		address keyToMove = managerIndex[managerIndex.length-1];
		managerIndex[rowToDelete] = keyToMove;
		Managers[keyToMove].index = rowToDelete;
		managerIndex.length--;

		return true;
	}

	function getManagersLength() constant returns (uint){
		return managerIndex.length;
	}

	function getManager(uint index) constant returns (bytes32, address){
		ManagerStruct ms = Managers[managerIndex[index]];
		return (ms.firstname, managerIndex[index]);
	}

	function getArrayData() constant returns (bytes32[] _data1) {

		uint arrLength = managerIndex.length;
        bytes32[] memory arrData1 = new bytes32[](arrLength);
        for (uint i=0; i < arrLength; i++){
        	address addr = managerIndex[i];
			ManagerStruct ms = Managers[addr];
            arrData1[i] = ms.firstname;
        }

        return (arrData1);
    }

	function getAllManagers() constant returns (bytes32[] _data1) {
		uint length = managerIndex.length;
		bytes32[] memory firstname = new bytes32[](length);
		bytes32[] memory lastname = new bytes32[](length);
		bytes32[] memory email = new bytes32[](length);
		address[] memory addrs = new address[](length);
		for (uint i = 0; i < managerIndex.length; i++) {
			ManagerStruct memory ms = Managers[managerIndex[i]];
			firstname[i] = ms.firstname;
			lastname[i] = ms.lastname;
			email[i] = ms.email;
			addrs[i] = managerIndex[i];
		}
		return (firstname);
	}


}
