pragma solidity ^0.4.18;


import "../../doug/Doug.sol";


// The Doug contract.
contract FundConstructor is Doug {

    address nous;

    string public fundName;

    bytes32 public fundType;

    function FundConstructor(address _nous, address _fundOwn, string _fundName, bytes32 _fundType) {
        nous = _nous;
        owner = _fundOwn;
        fundName = _fundName;
        fundType = _fundType;
    }
}
