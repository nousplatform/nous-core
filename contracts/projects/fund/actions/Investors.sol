pragma solidity ^0.4.18;


import "../interfaces/InvestorsProvider.sol";
import "./Wallets.sol";


contract Investors is Wallets {

    function addInvestor(address _investorAddress, uint256 _nousTkn) internal returns (bool) {
        require(_investorAddress != 0x0);

        address investorsDb = getContractAddress("investors_db");
        return InvestorsProvider(investorsDb).addInvestor(_investorAddress, _nousTkn);
    }

    /*function removeInvestor(address _investorAddress) internal returns (bool) {
        require(_investorAddress != 0x0);

        address investorsDb = getContractAddress("investors_db");
        return  InvestorsProvider(investorsDb).deleteInvestor(_investorAddress);
    }*/
}
