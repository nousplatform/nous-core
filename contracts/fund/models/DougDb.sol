pragma solidity 0.4.18;

contract DougDb {
    // This is where we keep all the contracts.
    struct Element {
        address contractAddress;
        uint256 index;
        bool doNotOverwrite;
    }

    mapping (bytes32 => Element) public list;

    bytes32[] public listIndex; // Managers

    function _addOrUpdateElement(bytes32 _name, address _addr, bool _doNotOverwrite) internal returns (bool) {
        Element elem = list[_name];
        if (elem.doNotOverwrite == true) return false;

        elem.contractAddress = _addr;
        elem.index = listIndex.push(_name) - 1;
        elem.doNotOverwrite = _doNotOverwrite;
    }

    function _removeElement(bytes32 _name) internal returns(bool) {
        if (list[_name].doNotOverwrite == true) return false;

        uint rowToDelete = list[_name].index;
        address keyToMove = listIndex[listIndex.length - 1];
        listIndex[rowToDelete] = keyToMove;
        list[keyToMove].index = rowToDelete;
        listIndex.length--;
        return true;
    }
}
