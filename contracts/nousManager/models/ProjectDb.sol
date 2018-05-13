pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


interface ProjectDbInterface {
    function addFund(address _owner, address _fundAddr, string _fundName, string _type) external returns(bool);
    function getOwnerFundLast(address _owner) external view returns(address);
}


contract ProjectDb is Validee {

    event CreateFund(address indexed owner, address indexed fund, string projectName, string projectType);

    struct ProjectStruct {
        bytes32 name;
        bytes32 type_;
        address owner;
        uint256 index;
        //mapping (bytes32 => address) contracts; // можно убрать
        //bytes32[] indexContracts;
    }

    // address fund => index found
    mapping (address => ProjectStruct) public funds;

    address[] public fundsIndex;

    // owner => Fund
    mapping (address => address[]) public fundOwnersIndex;


    function addFund(address _owner, address _addr, string _name, string _type) public returns(bool) {
        if (!validate()) {
            return false;
        }

        uint256 _fundIndex = fundsIndex.push(_addr) - 1;
        fundOwnersIndex[_owner].push(_addr);

        funds[_addr] = ProjectStruct({
            name: sha3(_name),
            type_: sha3(_type),
            owner: _owner,
            index: _fundIndex
        });

        emit CreateFund(_owner, _addr, _name, _type);
        return true;
    }

    function getOwnerFundLast(address _owner) external view returns(address) {
        return fundOwnersIndex[_owner][fundOwnersIndex[_owner].length - 1];
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
