pragma solidity ^0.4.11;

import "../../../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol";
import "../../../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract NousToken is StandardToken, Ownable {

	string public constant name = "Nous token";

	string public constant symbol = "NOUS";

	uint32 public constant decimals = 18;

	address public saleAgent;

	event Mint(address indexed to, uint256 amount);
  	event MintFinished();

	bool public mintingFinished = false;

 	struct SalesAgent {                     // These are contract addresses that are authorised to mint tokens
		address saleContractAddress;        // Address of the contract
		bytes32 saleContractType;           // Type of the contract ie. presale, crowdsale
		bool finalised;                     // Has this sales contract been completed and the ether sent to the deposit address?
		bool exists;                        // Check to see if the mapping exists
	}

	modifier canMint() {
		require(!mintingFinished);
		_;
	}

	/**
	* @dev Function change owner
	* @param _newSaleAgent Address new sale agent contract
	*/
	function nextSaleAgent(address _newSaleAgent) onlyOwner {
		saleAgent = _newSaleAgent;
		transferOwnership(_newSaleAgent);
	}

 	/**
  	* @dev Function to mint tokens
  	* @param _to The address that will receive the minted tokens.
  	* @param _amount The amount of tokens to mint.
  	* @return A boolean that indicates if the operation was successful.
	*/
 	function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
		totalSupply = totalSupply.add(_amount);
		balances[_to] = balances[_to].add(_amount);
		Mint(_to, _amount);
		Transfer(0x0, _to, _amount);
		return true;
  	}

	/**
	* @dev Function to stop minting new tokens.
	* @return True if the operation was successful.
	*/
	function finishMinting() onlyOwner public returns (bool) {
		mintingFinished = true;
		MintFinished();
		return true;
	}
}
