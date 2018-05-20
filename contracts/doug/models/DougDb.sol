pragma solidity ^0.4.4;


import "../interfaces/Validator.sol";
import "../safety/DougEnabled.sol";


contract DougDb {

    mapping (bytes32 => address) public contracts;

    bytes32[] public listIndex;

    //@dev Attention Add a new contract Or owerwrite old contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    function _addElement(bytes32 _name, address _addr)
    internal
    {
        if (contracts[_name] == 0x0) {
            listIndex.push(_name);
        }
        contracts[_name] = _addr;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 _name)
    internal
    returns(bool result) {

        for (uint _i  = 0; _i < listIndex.length; _i++) {
            if (_name == listIndex[_i]) break;
        }

        bytes32 keyToMove = listIndex[listIndex.length - 1];
        contracts[_name] = 0x0;
        listIndex[_i] = keyToMove;
        listIndex.length--;
        return true;
    }


}
