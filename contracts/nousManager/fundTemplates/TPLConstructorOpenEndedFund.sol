pragma solidity ^0.4.18;


import {OpenEndedFund} from "../../projects/openEndedFund/OpenEndedFund.sol";


contract TPLConstructorOpenEndedFund {
    function create(address _fundOwn, string _fundName, string _fundType, bytes32[] _names, address[] _addrs, bool[] _overWr) public
    returns (address) {
        return new OpenEndedFund(_fundOwn, _fundName, _fundType, _names, _addrs, _overWr);
    }
}
