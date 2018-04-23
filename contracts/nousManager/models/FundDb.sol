pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


interface FundDbInterface {
    function addFund(address _owner, address _fundAddr, string _fundName) external returns(bool);
}


contract FundDb is Validee {

    event CreateFund(address indexed owner, address indexed fund, string fundName);

    struct FundStructure {
        string fundName;
        mapping (bytes32 => address) fundContracts; // можно убрать
        bytes32[] indexContracts;
        address owner;
        uint256 index;
    }

    /// address fund => structure found
    mapping (address => FundStructure) public funds;

    /// last created funds user owner
    mapping (address => uint256[]) ownerFundIndex;

    address[] fundsIndex;

    function addFund(address _owner, address _fundAddr, string _fundName) public returns(bool) {
        if (!validate()) {
            return false;
        }

        uint256 _fundIndex = fundsIndex.push(_fundAddr) - 1;
        ownerFundIndex[_owner].push(_fundIndex);

        FundStructure memory newFund;
        newFund.fundName = _fundName;
        newFund.owner = _owner;
        newFund.index = _fundIndex;
        funds[_fundAddr] = newFund;

        //emit CreateFund(_owner, _fundAddr, _fundName);
        return true;
    }

    /**
    * gets all funds
    */
    function getAllFunds() public constant returns (address[]) {
        address[] memory alladdr = new address[](fundsIndex.length);
        for (uint8 i = 0; i < fundsIndex.length; i++) {
            alladdr[i] = fundsIndex[i];
        }
        return alladdr;
    }

}
