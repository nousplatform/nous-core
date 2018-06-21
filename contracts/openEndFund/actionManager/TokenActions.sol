pragma solidity ^0.4.18;


import {LockedActionManager} from "./LockedActionManager.sol";
import {OpenEndedTokenInterface as OpenEndedToken} from "../token/OpenEndedToken.sol";
import "../../doug/safety/DougEnabled.sol";


contract TokenActions is DougEnabled, LockedActionManager {

    /**
    * @notice Action Add Wallet
    */
    function actionAirdropToken(
        address _accountHolder,
        uint256 _amountOf
    )
    isLocked
    onlyRole(ROLE_NOUS_PLATFORM)
    external
    {
        require(_amountOf > 0);
        require(_accountHolder != 0x0);

        address _oet = getContractAddress("OpenEndedToken");
        OpenEndedToken(_oet).airdropToken(_accountHolder, _amountOf);
    }

}
