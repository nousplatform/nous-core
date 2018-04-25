pragma solidity ^0.4.18;


//import {Doug} from "../../doug/Doug.sol";


// The Doug contract.
contract FundConstructor /*is Doug*/ {

    address nous;

    address owner;

    string public fundName;

    bytes32 public fundType;

    function FundConstructor(address _nous, address _fundOwn, string _fundName, bytes32 _fundType)
    //Doug(_names, _addrs)
    {
        nous = _nous;
        owner = _fundOwn;
        fundName = _fundName;
        fundType = _fundType;
    }
}
