pragma solidity ^0.4.18;


//import "../../doug/ownable/SubOwnerDougContracts.sol";
import "../../doug/Doug.sol";
import "../../doug/safety/DougProtectionRewriting.sol";


// The Doug contract.
contract ProjectConstructor is DougProtectionRewriting {

    address public fundOwner;

    string public fundName;

    string public fundType;

    constructor(
        address _fundOwn,
        string _fundName,
        string _fundType,
        bytes32[] _cNames,
        address[] _cAddrs,
        bool[] _cOverWr
    ) public
        DougProtectionRewriting(_cNames, _cOverWr)
        Doug(_cNames, _cAddrs)
    {
        fundOwner = _fundOwn;
        fundName = _fundName;
        fundType = _fundType;
    }

}
