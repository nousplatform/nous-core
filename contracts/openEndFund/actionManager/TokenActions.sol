pragma solidity ^0.4.18;


import {LockedActionManager} from "./LockedActionManager.sol";
import {OpenEndedToken} from "../token/OpenEndedToken.sol";
import "../../doug/safety/DougEnabled.sol";


contract TokenActions is DougEnabled, LockedActionManager {

    /**
    * @notice Action airdrop tokens to owner wallet
    */
    function actionAirdropToken(
        uint256 _amountOf
    )
    public
    isLocked
    onlyRole(ROLE_NOUS_PLATFORM)
    returns(bool success)
    {
        require(_amountOf > 0);

        address _oet = getContractAddress("OpenEndedToken");
        OpenEndedToken(_oet).airdropToken(_amountOf);
        return true;
    }

    function actionAddAddressToAllowPurchases(address _addr)
    public
    isLocked
    onlyRole(ROLE_NOUS_PLATFORM)
    returns(bool success)
    {
        require(_addr != 0x0);
        address _oet = getContractAddress("OpenEndedToken");
        OpenEndedToken(_oet).addAddressToAllowPurchases(_addr);
    }

}
