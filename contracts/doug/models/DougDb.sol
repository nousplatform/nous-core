pragma solidity ^0.4.4;


import "../interfaces/Validator.sol";
import "../safety/DougEnabled.sol";


contract DougDb {

    mapping (bytes32 => address) public contractList;

    bytes32[] public listIndex;

    function isElement(bytes32 _name) internal constant returns(bool) {
        if(listIndex.length == 0) return false;
        return contractList[_name] != 0x0;
    }

    //@dev Attention Add a new contract Or owerwrite old contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    function _addElement(bytes32 _name, address _addr) internal returns (bool result) {
        if (contractList[_name] == 0x0) {
            listIndex.push(_name);
        }
        contractList[_name] = _addr;
        return true;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 _name) internal returns(bool result) {
        if (!isElement(_name)) return false;

        for (uint _i  = 0; _i < listIndex.length; _i++) {
            if (_name == listIndex[_i]) break;
        }

        bytes32 keyToMove = listIndex[listIndex.length - 1];
        contractList[_name] = 0x0;
        listIndex[_i] = keyToMove;
        listIndex.length--;
    }


}
