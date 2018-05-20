pragma solidity ^0.4.18;


import {Doug} from "../doug/Doug.sol";

contract ProjectConstructor is Doug {

    string public fundName;

    string public fundType;

    constructor(
        string _fundName,
        string _fundType,
        bytes32[] _names,
        address[] _addrs
    )
    Doug(_names, _addrs)
    {
        fundName = _fundName;
        fundType = _fundType;
    }
}
