pragma solidity ^0.4.18;


import "./BaseSaleAgent.sol";
import "./TGESchedule.sol";
//import "../token/SampleCrowdsaleToken.sol";
import "../fund/interfaces/SampleCrowdsaleTokenInterface.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "../base/Construct.sol";


contract Sale is BaseSaleAgent, TGESchedule {

    function Sale(
        address _owner,
        uint256 _totalSupplyCap,
        uint256 _retainedByCompany,
        address _walletAddress,
        address _nousToken,
        address _tokenAddress
    ) {
        require(_owner != 0x0);
        require(_totalSupplyCap > 0);
        require(_retainedByCompany > 0);
        require(_walletAddress != 0x0);
        require(_nousToken != 0x0);
        require(_tokenAddress != 0x0);

        owner = _owner;
        totalSupplyCap = _totalSupplyCap * EXPONENT;
        retainedByCompany = _retainedByCompany * EXPONENT;
        walletAddress = _walletAddress;
        nousToken = _nousToken;
        tokenAddress = _tokenAddress;
    }

    function() external payable {
        revert();
    }

    /**
    * Get notify in token contracts, only nous token
    * @param _from Sender coins
    * @param _value The max amount they can spend
    */
    function receiveApproval(address _from, uint256 _value) public returns (bool) {
        SalesAgent memory currentSaleAgent = salesAgents[salesAgents.length - 1];
        require(finalizeICO == false && now > currentSaleAgent.startTime && now < currentSaleAgent.endTime);
        require(_value > 0 && currentSaleAgent.minDeposit <= _value && _value < currentSaleAgent.maxDeposit);
        require(_from != 0x0 && msg.sender == nousToken);

        ERC20 nt = ERC20(nousToken); //_tknAddress
        uint256 amount = nt.allowance(_from, this);

        // how many coins we are allowed to spend
        if (amount >= _value) {
            if (nt.transferFrom(_from, this, _value)) {
                uint256 _totalAmount = getBonusRate(_value, currentSaleAgent.rate);
                assert(nt.totalSupply().add(_totalAmount) <= totalSupplyCap);
                assert(currentSaleAgent.tokensMinted.add(_totalAmount) <= currentSaleAgent.tokensLimit);

                SampleCrowdsaleTokenInterface(tokenAddress).mint(_from, _totalAmount);
                currentSaleAgent.tokensMinted = currentSaleAgent.tokensMinted.add(_totalAmount);
                nt.transfer(walletAddress, _value); // send nous token to wallet
                return true;
            }
        }
        return false;
    }

}
