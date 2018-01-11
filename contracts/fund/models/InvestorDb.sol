pragma solidity ^0.4.18;

import "../interfaces/ContractProvider.sol";
import "../interfaces/Construct.sol";
import "../base/FundManagerEnabled.sol";
import "../../token/ERC20.sol";


contract InvestorDb  is FundManagerEnabled, Construct {

	mapping (address => uint256) investors;

	address[] public investorsIndex;

	function addInvestor(address addr) public returns(bool) {
		require(isFundManager());
		investors[addr] = investorsIndex.push(addr)-1;
		return true;
	}

	/*function deleteInvestor(address addr) public returns(bool) {
		require(isFundManager());
		//require(investors[addr]);
		uint256 rowToDelete = investors[addr];
		address keyToMove = investorsIndex[investorsIndex.length-1];
		investorsIndex[rowToDelete] = keyToMove;
		investors[keyToMove] = rowToDelete;
		investorsIndex.length--;
		return true;
	}*/

	function getAllBalances() public constant returns(address[], uint256[]) {
		uint256 length = investorsIndex.length;
		address[] memory _investors = new address[](length);
		uint256[] memory _balances = new uint256[](length);
		ERC20 FundTkn = ERC20(ContractProvider(DOUG).contracts("fund_tokens"));
		for (uint256 i; i < length; i++) {
			_investors[i] = investorsIndex[i];
			_balances[i] = FundTkn.balanceOf(investorsIndex[i]);
		}
		return (_investors, _balances);
	}
}
