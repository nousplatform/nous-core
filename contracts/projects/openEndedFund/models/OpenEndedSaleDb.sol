pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


contract OpenEndedSaleDb is Validee {

    uint256 entryFee;

    uint256 exitFee;

    uint256 managementFee;

    uint256 maxInvestors;

    constructor(uint256 _entryFee, uint256 _exitFee, uint256 _managementFee, uint256 _maxInvestors) public {

    }

}
