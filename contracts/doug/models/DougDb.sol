pragma solidity ^0.4.4;


import "../interfaces/Validator.sol";
import "../safety/DougEnabled.sol";


contract DougDb {

    // List element
    struct Element {
        address contractAddress;
        bool lockOverwriting;
        uint256 index;
    }

    mapping (bytes32 => Element) public list;
    bytes32[] public listIndex; // Managers

    function isElement(bytes32 _elementName) internal returns(bool) {
        if (listIndex.length == 0) return false;
        return listIndex[list[_elementAddress].index] == _elementAddress;
    }

    //@dev Attention Add a new contract Or owerwrite old contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    function _addElement(bytes32 _name, address _addr, bool _overWr) internal returns (bool result) {
        Element memory elem;
        if (elem.lockOverwriting == true) return false; //overwrite protection

        elem.contractAddress = _addr;
        elem.index = listIndex.push(_name) - 1;
        elem.lockOverwriting = _overWr;
        list[_name] = elem;
        return true;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 _name) internal returns(bool result) {
        if (elem.lockOverwriting == true) return false; //overwrite protection
        if (listIndex[list[_name].index] != _name) return false;

        uint rowToDelete = list[_name].index;
        bytes32 keyToMove = listIndex[listIndex.length - 1];
        listIndex[rowToDelete] = keyToMove;
        list[keyToMove].index = rowToDelete;
        listIndex.length--;
        return true;
    }

    // Should be safe to update to returning 'Element' instead
    function getAllElement(bytes32 name) public constant returns (bytes32 contractName, address contractAddress, bool contractLockOverwriting) {

        Element elem = list[name];
        if(elem.contractName == "") {
            return;
        }
        contractName = elem.contractName;
        contractAddress = elem.contractAddress;
        contractLockOverwriting = elem.lockOverwriting;
    }

}
