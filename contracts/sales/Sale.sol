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
        address _nousToken
    ) {
        require(_owner != 0x0);
        require(_totalSupplyCap > 0);
        require(_retainedByCompany > 0);
        require(_walletAddress != 0x0);
        require(_nousToken != 0x0);

        owner = _owner;
        totalSupplyCap = _totalSupplyCap;
        retainedByCompany = _retainedByCompany;
        walletAddress = _walletAddress;
        nousToken = _nousToken;
    }

    function() external payable {
        revert();
    }

    function constructor(address _tokenAddress) public {
        require(!constructorCall);
        require(_tokenAddress != address(0));

        constructorCall = true;
        tokenAddress = _tokenAddress;
    }

    /**
    * Get notify in token contracts, only nous token
    * @param _from Sender coins
    * @param _value The max amount they can spend
    * @param _tknAddress Address token contract, where did the money come from
    * @param _extraData SomeExtra Information
    */
    function receiveApproval(address _from, uint256 _value, address _tknAddress, bytes _extraData)
    public returns (bool) {
        SalesAgent memory currentSaleAgent = salesAgents[salesAgents.length - 1];
        require(currentSaleAgent.isFinalized == false && now > currentSaleAgent.startTime && now < currentSaleAgent.endTime);
        require(_value > 0 && currentSaleAgent.minDeposit >= _value && currentSaleAgent.maxDeposit < _value);
        require(_from != 0x0 && _tknAddress == nousToken && _value > 0);

        ERC20 nt = ERC20(_tknAddress);
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
