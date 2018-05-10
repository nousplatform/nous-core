pragma solidity ^0.4.18;


//import "../../doug/ownable/SubOwnerDougContracts.sol";
//import "../../doug/Doug.sol";
import "../../doug/safety/DougProtectionRewriting.sol";


// The Doug contract.
contract ProjectConstructor is DougProtectionRewriting {

    address public fundOwner;

    string public fundName;

    constructor(
        address _fundOwn,
        string _fundName,
        //address _nousToken,
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
        //_addElement("NousToken", _nousToken);
    }



}
