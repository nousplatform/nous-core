pragma solidity ^0.4.18;


import {DougDb} from "./models/DougDb.sol";
import "./safety/DougEnabled.sol";


contract DougInterface {
    mapping (bytes32 => address) public contracts;
    function addContract(bytes32 _name, address _addr) public;
    function removeContract(bytes32 _name) external;
}

contract Doug is DougDb {

    event AddContract(address /*indexed*/ caller, bytes32 /*indexed*/ name, address contractAddress);

    event RemoveContract(address indexed caller, bytes32 indexed name, address contractAddress);

    modifier onlyActionManager() {
        require(contracts["ProjectActionManager"] == msg.sender);
        _;
    }

    constructor(
        bytes32[] _names,
        address[] _addrs
    )
    public
    {
        for (uint i; i < _names.length; i++) {
            require(_names[i] != bytes32(0), "Contract name is empty.");
            require(_addrs[i] != 0x0, "Contract address is empty.");

            _setDougAddress(_addrs[i]);
            _addElement(_names[i], _addrs[i]);

            emit AddContract(0x0, _names[i], _addrs[i]);
        }
    }

    // ---
    function _setDougAddress(address _addr)
    internal
    returns(bool)
    {
        return DougEnabled(_addr).setDougAddress(address(this));
    }

    // ---
    function addContract(bytes32 _name, address _addr)
    public
    onlyActionManager
    {
        require(_name != bytes32(0), "Contract name is empty.");
        require(_addr != 0x0, "Contract address is empty.");

        _setDougAddress(_addr);
        _addElement(_name, _addr);

        emit AddContract(msg.sender, _name, _addr);
    }

    // ---
    function removeContract(bytes32 _name)
    external
    onlyActionManager
    {
        require(_name != bytes32(0), "Contract name is empty.");
        require(contracts[_name] != 0x0, "Contract address is empty.");

        address _removeContract = contracts[_name];
        DougEnabled(_removeContract).remove();
        _removeElement(_name);

        emit RemoveContract(msg.sender, _name, _removeContract);
    }

    // Should be safe to update to returning 'Element' instead
    function getAllContracts()
    public
    view
    returns (
        bytes32[] memory contractName,
        address[] memory contractAddress)
    {
        uint length = listIndex.length;
        contractName = new bytes32[](length);
        contractAddress = new address[](length);
        for (uint i = 0; i < length; i++) {
            contractName[i] = listIndex[i];
            contractAddress[i] = contracts[listIndex[i]];
        }
        return (contractName, contractAddress);
    }

    function countContracts()
    public
    view
    returns(uint)
    {
        return listIndex.length;
    }

}
