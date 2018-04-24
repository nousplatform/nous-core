pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./safety/DougEnabled.sol";
import "./models/DougDb.sol";

import {ActionManager} from "./ActionManager.sol";
import {ActionDb} from "./models/ActionDb.sol";
import "./models/PermissionsDb.sol";


interface DougInterface {
    function contracts(bytes32 _name) public view returns (address addr);
    function addContract(bytes32 name, address addr) public returns (bool result);
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

    function Doug() {

        //address am = new ActionManager();
        //require(addContract("action_manager", am));

        //address adb = new ActionDb();
        //require(addContract("ActionDb", adb));

        //address pdb = new PermissionsDb(msg.sender);
        //require(addContract("PermissionDb", adb));
    }

    /// @notice Add a contract to Doug. This contract should extend DougEnabled, because
    /// Doug will attempt to call 'setDougAddress' on that contract before allowing it
    /// to register. It will also ensure that the contract cannot be selfdestructed by anyone
    /// other than Doug. Finally, Doug allows over-writing of previous contracts with
    /// the same name, thus you may replace contracts with new ones.
    /// @param _name The bytes32 name of the contract.
    /// @param _addr The address to the actual contract.
    /// @return { "result": "showing if the adding succeeded or failed." }
    function addContract(bytes32 _name, address _addr) public returns (bool result) {
        // Only the owner may add, and the contract has to be DougEnabled and
        // return true when setting the Doug address.

        if (msg.sender != owner || !DougEnabled(_addr).setDougAddress(address(this))) {
            // Access denied. Should divide these up into two maybe.
            AddContract(msg.sender, _name, 403);
            //revert();
            return false;
        }
        // Add to contract.
        bool ae = _addElement(_name, _addr);
        if (ae) {
            AddContract(msg.sender, _name, 201);
        } else {
            // Can't overwrite.
            AddContract(msg.sender, _name, 409);
        }
        //require(ae);
        return ae;
    }

    /// @notice Remove a contract from doug.
    /// @param _name The bytes32 name of the contract.
    /// @return { "result": "showing if the adding succeeded or failed." }
    function removeContract(bytes32 _name) public returns (bool result) {
        if(msg.sender != owner) {
            RemoveContract(msg.sender, _name, 403);
            return false;
        }
        bool re = _removeElement(_name);
        if(re) {
            RemoveContract(msg.sender, _name, 200);
        } else {
            // Can't remove, it's already gone.
            RemoveContract(msg.sender, _name, 410);
        }
        return re;
    }

    /// @notice Gets a contract from Doug.
    /// @param _name The bytes32 name of the contract.
    /// @return { "addr": "The address of the contract." } If no contract with that name exists, it will
    function contracts(bytes32 _name) public view returns (address addr) {
        return list[_name].contractAddress;
    }

    /// @notice Remove (selfdestruct) Doug.
    function remove() public onlyOwner {
        selfdestruct(owner);
    }

}
