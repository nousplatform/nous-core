pragma solidity ^0.4.4;

contract NousManagerDb {

    struct FundStructure {
        string fundName;
        mapping (bytes32 => address) childFundContracts;
        bytes32[] indexChild;
        uint256 index;
    }

    /// address fund => structure found
    mapping (address => FundStructure) public funds;

    /// Owner fund index fund.
    mapping (address => uint256) ownerFundIndex;

    address[] fundsIndex;

    mapping (bytes32 => address) public defaultContracts;

    bytes32[] contractsList;

    address public nousTokenAddress = 0x4dd59912ca031ace5524f22f78226d338bc513aa;
}
