pragma solidity ^0.4.18;


import "../interfaces/ContractProvider.sol";
import "../../base/Construct.sol";
import "../base/FundManagerEnabled.sol";
import "../../token/ERC20.sol";


contract InvestorDb is FundManagerEnabled, Construct {

    // address investor to balance nous tkn
    mapping (address => uint256) public investors;

    address[] public investorsIndex;

    /**
    * Add investor and nous tkn
    */
    function addInvestor(address _addr, uint256 _nousTkn) public returns (bool) {
        require(isFundManager());
        investors[_addr] = investors[_addr] + _nousTkn;
        investorsIndex.push(_addr);
        return true;
    }

    /**
    * Get all balances
    */
    function getAllBalances() public constant returns (address[], uint256[]) {
        uint256 length = investorsIndex.length;
        address[] memory _investors = new address[](length);
        uint256[] memory _balances = new uint256[](length);
        ERC20 fundTkn = ERC20(ContractProvider(DOUG).contracts("fund_tokens"));
        for (uint256 i; i < length; i++) {
            _investors[i] = investorsIndex[i];
            _balances[i] = fundTkn.balanceOf(investorsIndex[i]);
        }
        return (_investors, _balances);
    }

}
