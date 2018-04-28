pragma solidity ^0.4.18;


import {Doug} from "../Doug.sol";


contract SubOwnerDougContracts is Doug {

    address subOwner;

    bool updateAllow = false;

    bool removeAllow = false;

    modifier onlySubOwner() {
        require(msg.sender == subOwner);
        _;
    }

    function SubOwnerDougContracts(address _subOwner) {
        subOwner = _subOwner;
    }

    function addContract(bytes32 _name, address _addr) public returns (bool result) {
        require(updateAllow);
        updateAllow = false;
        return super.addContract(_name, _addr);
    }

    function removeContract(bytes32 _name) public returns (bool result) {
        require(removeAllow);
        removeAllow = false;
        return super.removeContract(_name);
    }

    function allowUpdateContract() public onlySubOwner returns(bool) {
        updateAllow = true;
    }

    function disallowUpdateContract() public onlySubOwner returns(bool) {
        updateAllow = false;
    }

    function allowRemoveContract() public onlySubOwner returns(bool) {
        removeAllow = true;
    }

    function disallowRemoveContract() public onlySubOwner returns(bool) {
        removeAllow = false;
    }
}
