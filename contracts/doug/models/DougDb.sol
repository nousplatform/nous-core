pragma solidity ^0.4.4;


import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "../interfaces/Validator.sol";
import "../safety/DougEnabled.sol";


contract DougDb {

    // List element
    struct Element {
        address contractAddress;
        uint256 index;
    }

    mapping (bytes32 => Element) list;
    bytes32[] public listIndex; // Managers


    // Add a new contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    function _addElement(bytes32 _name, address _addr) internal returns (bool result) {
        Element memory elem = list[_name];
        if (elem.doNotOverwrite == true) return false; //overwrite protection

        elem.contractAddress = _addr;
        elem.index = listIndex.push(_name) - 1;
        return true;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 _name) internal returns(bool result) {

        uint rowToDelete = list[_name].index;
        bytes32 keyToMove = listIndex[listIndex.length - 1];
        listIndex[rowToDelete] = keyToMove;
        list[keyToMove].index = rowToDelete;
        listIndex.length--;
        return true;
    }

    // Should be safe to update to returning 'Element' instead
    /*function getAllElement(bytes32 name) public constant returns (bytes32 contractName, address contractAddress) {

        Element elem = list[name];
        if(elem.contractName == "") {
            return;
        }
        contractName = elem.contractName;
        contractAddress = elem.contractAddress;
    }*/

}
