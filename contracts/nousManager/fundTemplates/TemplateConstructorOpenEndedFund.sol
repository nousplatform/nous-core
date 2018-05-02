pragma solidity ^0.4.18;


import "../../projects/openEndedFund/OpenEndedFund.sol";


contract TemplateConstructorOpenEndedFund {
    function create( address _fundOwn, string _fundName,/* string _fundType,*/ bytes32[] _names, address[] _addrs, bool[] _overWr) external
    returns (address) {
        return new OpenEndedFund(_fundOwn, _fundName, /*_fundType, */_names, _addrs, _overWr);
    }
}
