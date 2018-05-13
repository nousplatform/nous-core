pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./safety/DougEnabled.sol";
import "./models/DougDb.sol";
import "./interfaces/Validator.sol";
import {ActionManagerInterface as ActionManager} from "./ActionManager.sol";


contract DougInterface {
    function contracts(bytes32 _name) public constant returns (address addr);
    function addContract(bytes32 name, address addr, bool _overWr) public returns (bool result);
    function removeContract(bytes32 name) public returns (bool result);
}


/// @title DOUG
/// @author Andreas Olofsson
/// @notice This contract is used to register other contracts by name.
/// @dev Stores the contracts as entries in a doubly linked list, so that
/// the list of elements can be gotten.
contract Doug is DougDb, Ownable {

    // When adding a contract.
    event AddContract(address indexed caller, bytes32 indexed name, uint16 indexed code);
    // When removing a contract.
    event RemoveContract(address indexed caller, bytes32 indexed name, uint16 indexed code);

    constructor(bytes32[] _names, address[] _addrs) public {
        //require(_names.length == _addrs.length);
        for (uint i; i < _names.length; i++) {
            require(_addrs[i] != 0x0, "Contract address is empty.");
            require(_names[i] != bytes32(0), "Contract name is empty.");
            require(_setDougAddress(_addrs[i]));
            _addElement(_names[i],_addrs[i]);
        }
    }

    function _setDougAddress(address _addr) internal returns(bool) {
        return DougEnabled(_addr).setDougAddress(address(this));
    }

    /// @notice Add a contract to Doug. This contract should extend DougEnabled, because
    /// Doug will attempt to call 'setDougAddress' on that contract before allowing it
    /// to register. It will also ensure that the contract cannot be selfdestructed by anyone
    /// other than Doug. Finally, Doug allows over-writing of previous contracts with
    /// the same name, thus you may replace contracts with new ones.
    /// @param _name The bytes32 name of the contract.
    /// @param _addr The address to the actual contract.
    /// @return { "result": "showing if the adding succeeded or failed." }
    function addContract(bytes32 _name, address _addr) public onlyOwner returns (bool result) {
        // Only the owner may add, and the contract has to be DougEnabled and
        // return true when setting the Doug address.
        /*address am = contractList["ActionManager"];
        if (Validator(am).validate(msg.sender) || _setDougAddress(_addr)) {
            // Access denied. Should divide these up into two maybe.
            emit AddContract(msg.sender, _name, 403);
            return false;
        }*/
        // Add to contract.
        bool ae = _addElement(_name, _addr);
        if (ae) {
            emit AddContract(msg.sender, _name, 201);
        } else {
            // Can't overwrite.
            emit AddContract(msg.sender, _name, 409);
        }
        return ae;
    }

    /// @notice Remove a contract from doug.
    /// @param _name The bytes32 name of the contract.
    /// @return { "result": "showing if the adding succeeded or failed." }
    function removeContract(bytes32 _name) public onlyOwner returns (bool result) {
        /*address am = contractList["ActionManager"];
        if(Validator(am).validate(msg.sender)) {
            emit RemoveContract(msg.sender, _name, 403);
            return false;
        }*/
        bool re = _removeElement(_name);
        if(re) {
            emit RemoveContract(msg.sender, _name, 200);
        } else {
            // Can't remove, it's already gone.
            emit RemoveContract(msg.sender, _name, 410);
        }
        return re;
    }

    function contracts(bytes32 _name) public view returns(address) {
        if (!isElement(_name)) revert(); //return 0x0;
        return contractList[_name];
    }

    // Should be safe to update to returning 'Element' instead
    function getAllContracts() public constant returns (bytes32[] memory contractName, address[] memory contractAddress) {

        uint length = listIndex.length;
        contractName = new bytes32[](length);
        contractAddress = new address[](length);
        for (uint i = 0; i < length; i++) {
            contractName[i] = listIndex[i];
            contractAddress[i] = contractList[listIndex[i]];
        }
        return (contractName, contractAddress);
    }

    function countContracts() public constant returns(uint) {
        return listIndex.length;
    }


    /// @notice Remove (selfdestruct) Doug.
//    function remove() public onlyOwner {
//        selfdestruct(owner);
//    }

}
