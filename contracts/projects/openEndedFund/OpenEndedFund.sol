pragma solidity ^0.4.18;


import "../commonFunctions/ProjectConstructor.sol";


contract OpenEndedFund is ProjectConstructor {

    constructor(address _fundOwn, string _fundName, bytes32[] _cNames, address[] _cAddrs, bool[] _cOverWr)
    ProjectConstructor(_fundOwn, _fundName, _cNames, _cAddrs, _cOverWr) {

    }

}
