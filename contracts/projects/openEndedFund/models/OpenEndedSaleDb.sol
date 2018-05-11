pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


contract OpenEndedSaleDb is Validee {

    uint256 entryFee;

    uint256 exitFee;

    uint256 managementFee;

    // Amount of nous token raised
    uint256 public NSURaised;

    //uint256 maxInvestors;


    // ToDo protection
    function setParams(uint256 _entryFee, uint256 _exitFee, uint256 _managementFee/*, uint256 _maxInvestors*/) public {
        entryFee = _entryFee;
        exitFee = _exitFee;
        managementFee = _managementFee;
        //maxInvestors = _maxInvestors;
    }

}
