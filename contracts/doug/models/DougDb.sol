pragma solidity ^0.4.4;


import "../interfaces/Validator.sol";
import "../safety/DougEnabled.sol";


contract DougDb {

    // List element
    struct Element {
        address addr;
        uint256 index;
    }

    mapping (bytes32 => Element) private contractList;

    bytes32[] public listIndex;

    function isElement(bytes32 _name) internal constant returns(bool) {
        if(listIndex.length == 0) return false;
        return (listIndex[contractList[_name].index] == _name);
    }

    //@dev Attention Add a new contract Or owerwrite old contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    function _addElement(bytes32 _name, address _addr) internal returns (bool result) {
        contractList[_name].addr = _addr;
        contractList[_name].index = listIndex.push(_name) - 1;
        return true;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 _name) internal returns(bool result) {
        if (!isElement()) return false;

        uint rowToDelete = contractList[_name].index;
        bytes32 keyToMove = listIndex[listIndex.length - 1];
        listIndex[rowToDelete] = keyToMove;
        contractList[keyToMove].index = rowToDelete;
        listIndex.length--;
        return true;
    }


}
