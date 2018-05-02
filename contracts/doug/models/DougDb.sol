pragma solidity ^0.4.4;


import "../interfaces/Validator.sol";
import "../safety/DougEnabled.sol";


contract DougDb {

    // List element
    struct Element {
        address contractAddress;
        uint256 index;
    }

    mapping (bytes32 => bool) notOverWrite;

    mapping (bytes32 => Element) public list;

    bytes32[] public listIndex;

    //@dev Attention Add a new contract Or owerwrite old contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    function _addElement(bytes32 _name, address _addr) internal returns (bool result) {
        Element memory _elem;

        _elem.contractAddress = _addr;
        _elem.index = listIndex.push(_name) - 1;
        list[_name] = _elem;
        return true;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 _name) internal returns(bool result) {
        Element memory _elem = list[_name];

        if (listIndex[list[_name].index] != _name) return false;

        uint rowToDelete = list[_name].index;
        bytes32 keyToMove = listIndex[listIndex.length - 1];
        listIndex[rowToDelete] = keyToMove;
        list[keyToMove].index = rowToDelete;
        listIndex.length--;
        return true;
    }

    // Should be safe to update to returning 'Element' instead
    function getAllElement(bytes32 name) public constant returns (bytes32 contractName, address contractAddress) {

        Element memory _elem = list[name];
        if(_elem.contractAddress == 0x0) {
            return;
        }
        contractName = name;
        contractAddress = _elem.contractAddress;
    }

}
