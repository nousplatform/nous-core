pragma solidity ^0.4.4;

contract DougDB {

	struct Element {
		bytes32 contractName;
		address contractAddress;
		uint index;
	}

	mapping (bytes32 => Element) list;

	bytes32[] private elementIndex;

	function isElement(bytes32 name) returns (bool){
		if(elementIndex.length == 0) return false;
		return (elementIndex[list[name].index] == name);
	}

	// Add a new contract. This will overwrite an existing contract. 'internal' modifier means
  	// it has to be called by an implementing class.
	function _addElement(bytes32 name, address addr) internal returns (bool result) {

 		if(isElement(name)) {
 			return false;
 		}

		Element elem = list[name];
		elem.contractName = name;
		elem.contractAddress = addr;
		elem.index = elementIndex.push(name)-1;
		return true;
	}

	// Remove a contract from Doug (we could also selfdestruct the contract if we want to).
	function _removeElement(bytes32 name) internal returns (bool result) {

		if(isElement(name)) {
			return false;
		}

		uint rowToDelete = list[name].index;
		bytes32 keyToMove = elementIndex[elementIndex.length-1];
		elementIndex[rowToDelete] = keyToMove;
		list[keyToMove].index = rowToDelete;
		elementIndex.length--;
		return true;
	}

	// Update element from Doug
	function _updateElement(bytes32 name, address addr) internal returns (bool result) {

		if(!isElement(name)) {
			return false;
		}
		list[name].contractAddress = addr;
		return true;
	}

	function getElement(bytes32 name) constant returns (bytes32 contractName, address contractAddress, uint contractIndex) {

		Element elem = list[name];
		if(elem.contractName == ""){
			return;
		}

		contractName = elem.contractName;
		contractAddress = elem.contractAddress;
		contractIndex = elem.index;
	}

}
