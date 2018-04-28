pragma solidity ^0.4.18;


import "../../doug/ownable/SubOwnerDougContracts.sol";


// The Doug contract.
contract FundConstructor is SubOwnerDougContracts {

    address public fundOwner;

    string public fundName;

    string public fundType;

    function FundConstructor(address _fundOwn, string _fundName, string _fundType, bytes32[] _names, address[] _addrs)
    public
    SubOwnerDougContracts(_fundOwn)
    Doug(_names, _addrs)
    {
        fundOwner = _fundOwn;
        fundName = _fundName;
        fundType = _fundType;
    }

}
