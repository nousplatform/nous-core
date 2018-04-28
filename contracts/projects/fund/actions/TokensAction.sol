pragma solidity ^0.4.18;

contract TokensAction {

    /*function buyTokens(address beneficiary, uint256 tokens) public payable returns (bool) {
        require(saleState == SaleState.Active);
        // if sale is frozen TODO validate stop sale and send transaction
        require(beneficiary != 0x0);
        require(msg.value > 0);
        // TODO validate

        uint256 weiAmount = msg.value;

        BonusForAffiliate affiliate = BonusForAffiliate(affiliateAddr);
        address _referral = affiliate.getReferralAddress(beneficiary);

        if (_referral != address(0)) {
            uint256 bonus = weiAmount.mul(percentBonusForAffiliate).div(100);
            weiAmount = weiAmount.sub(bonus);
            affiliate.addBonus.value(bonus)(beneficiary, _referral);
        }

        tokenContract.mint(beneficiary, tokens);
        salesAgents[msg.sender].tokensMinted = salesAgents[msg.sender].tokensMinted.add(tokens);
        // increment tokensMinted

        RefundVault vaultContract = RefundVault(refundVaultAddr);

        vaultContract.deposit.value(weiAmount)(beneficiary);
        // transfer ETH to refund contract
        weiRaised = weiRaised.add(weiAmount);
        // increment wei Raised

        TokenPurchase(
            msg.sender,
            beneficiary,
            weiAmount,
            tokens
        );

        return true;
    }*/

}
