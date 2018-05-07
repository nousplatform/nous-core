pragma solidity ^0.4.18;


//import "../../doug/ownable/SubOwnerDougContracts.sol";
import "../../doug/Doug.sol";
import "../../doug/safety/DougProtectionRewriting.sol";


// The Doug contract.
contract ProjectConstructor is Doug, DougProtectionRewriting {

    address public fundOwner;

    string public fundName;

    constructor(
        address _fundOwn,
        string _fundName,
        bytes32[] _cNames,
        address[] _cAddrs,
        bool[] _cOverWr
    ) public
        //SubOwnerDougContracts(_fundOwn)
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
