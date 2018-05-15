pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";

contract OpenEndedSaleDbInterface {
    mapping(bytes32 => uint256) public params;
}


contract OpenEndedSaleDb is Validee {

    mapping(bytes32 => uint256) public params;

    constructor(bytes32[] _paramSale, uint256[] _valSale) public {
        for (uint i = 0; i < _paramSale.length; i++) {
            params[_paramSale[i]] = _valSale[i];
        }
    }

    function setEntryFee(uint _entryFee) external {
        require(validate());
        params["entryFee"] = _entryFee;
    }

    function setExitFee(uint _exitFee) external {
        require(validate());
        params["exitFee"] = _exitFee;
    }

    function setManagementFee(uint _managementFee) external {
        require(validate());
        params["managementFee"] = _managementFee;
    }
}
