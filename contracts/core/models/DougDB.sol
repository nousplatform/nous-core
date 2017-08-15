pragma solidity ^0.4.0;

//The Doug database contract.
contract DougDB {

    // List element
    struct Element {
        bytes32 prev;
        bytes32 next;
        // Data
        bytes32 contractName;
        address contractAddress;
    }

    uint public size;
    bytes32 public tail;
    bytes32 public head;

    mapping (bytes32 => Element) list;

    // Add a new contract. This will overwrite an existing contract. 'internal' modifier means
    // it has to be called by an implementing class.
    // TODO Прверить
    function _addElement(bytes32 name, address addr) internal returns (bool result) {
        Element elem = list[name];

        elem.contractName = name;
        elem.contractAddress = addr;

        // Two cases - empty or not.
        if (size == 0){
            tail = name;
            head = name;
        } else {
            list[head].next = name;
            list[name].prev = head;
            head = name;
        }
        size++;
        return true;
    }

    // Remove a contract from Doug (we could also selfdestruct the contract if we want to).
    function _removeElement(bytes32 name) internal returns (bool result) {

        Element elem = list[name];
        if(elem.contractName == ""){
            return false;
        }

        if(size == 1) {
            tail = "";
            head = "";
        } else if (name == head) {
            head = elem.prev;
            list[head].next = "";
        } else if(name == tail) {
            tail = elem.next;
            list[tail].prev = "";
        } else {
            bytes32 prevElem = elem.prev;
            bytes32 nextElem = elem.next;
            list[prevElem].next = nextElem;
            list[nextElem].prev = prevElem;
        }
        size--;
        delete list[name];
        return true;
  }

   // Should be safe to update to returning 'Element' instead
    function getElement(bytes32 name) constant returns (bytes32 prev, bytes32 next, bytes32 contractName, address contractAddress) {

        Element elem = list[name];
        if(elem.contractName == ""){
            return;
        }
        prev = elem.prev;
        next = elem.next;
        contractName = elem.contractName;
        contractAddress = elem.contractAddress;
    }
}
