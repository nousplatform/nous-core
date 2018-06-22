pragma solidity ^0.4.18;


import {Action} from "../../doug/actions/Mainactions.sol";


contract ActionsAirdropTokens is Action("owner")  {

    function execute(
        uint256 _amountOf
    )
    isActionManager_
    public
    {

    }
}
