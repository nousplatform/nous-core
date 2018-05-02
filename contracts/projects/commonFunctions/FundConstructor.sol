pragma solidity ^0.4.18;


import "../../doug/ownable/SubOwnerDougContracts.sol";
import "../../doug/safety/DougProtectionRewriting.sol";


// The Doug contract.
contract FundConstructor is SubOwnerDougContracts, DougProtectionRewriting {

    address public fundOwner;

    string public fundName;

    string public fundType;

    constructor(address _fundOwn, string _fundName, bytes32[] _cNames, address[] _cAddrs, bool[] _cOverWr) public
        SubOwnerDougContracts(_fundOwn)
        DougProtectionRewriting(_cNames, _cOverWr)
        Doug(_cNames, _cAddrs)
    {
        fundOwner = _fundOwn;
        fundName = _fundName;
    }

    function addContract(bytes32 _name, address _addr) public validateOverwrite(_name) returns (bool result) {
        return super.addContract(_name, _addr);
    }

}
