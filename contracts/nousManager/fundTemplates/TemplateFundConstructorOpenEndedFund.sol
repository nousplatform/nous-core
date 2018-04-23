pragma solidity ^0.4.18;


import "../../funds/openEndedFund/FundConstructor.sol";


contract TemplateFundConstructorOpenEndedFund {
    function create(address _doug, address _fundOwn, string _fundName, bytes32 _fundType) external returns (address) {
        return new FundConstructor(_doug, _fundOwn, _fundName, _fundType);
        //return 0x0;
    }
}
