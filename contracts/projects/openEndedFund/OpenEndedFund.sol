pragma solidity ^0.4.18;


import "../commonFunctions/ProjectConstructor.sol";


contract OpenEndedFund is ProjectConstructor {

    constructor(address _fundOwn, string _fundName, string _fundType, bytes32[] _cNames, address[] _cAddrs, bool[] _cOverWr) public
    ProjectConstructor(_fundOwn, _fundName, _fundType, _cNames, _cAddrs, _cOverWr) {

    }

}
