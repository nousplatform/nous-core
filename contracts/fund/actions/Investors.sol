pragma solidity ^0.4.18;


import "../interfaces/InvestorsProvider.sol";
import "./Wallets.sol";


contract Investors is Wallets {

    function addInvestor(address _investorAddress) internal returns (bool) {
        require(_investorAddress != 0x0);

        address investors_db = getContractAddress("investors_db");
        return InvestorsProvider(investors_db).addInvestor(_investorAddress);
    }

    function removeInvestor(address _investorAddress) internal returns (bool) {
        require(_investorAddress != 0x0);

        address investors_db = getContractAddress("investors_db");
        return  InvestorsProvider(investors_db).deleteInvestor(_investorAddress);
    }
}
