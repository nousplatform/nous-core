pragma solidity ^0.4.4;

/**
* Found Manager
* This components check user permission and coll actions on components
* Permission: (Nous platform = 4, Owner Fund = 3, Manager = 2, Investor = 1, No permission = 0 )
*
*/
import "./interfaces/FundInterface.sol";
import "../token/ERC20.sol";
import "./actions/Investors.sol";


// The fund manager
contract FundManager is Investors {

    function construct(address foundOwner, address nousaddress) {
		require(isCall);
    	//if (isCall) revert();
		//TODO ONLY FIRST START
    	owner = foundOwner;
        nous = nousaddress;
        fund = msg.sender;

        setPermission(nous, 4);
        setPermission(fund, 3);
        setPermission(owner, 3);

        isCall = true; // disabled constructor
		locked = false;
    }

	/**
	 * Get notify in token contracts, only nous token
	 *
	 * @param _from Sender coins
	 * @param _value The max amount they can spend
	 * @param _tkn_address Address token contract, where did the money come from
	 * @param _extraData SomeExtra Information
	 */
	function receiveApproval(address _from, uint256 _value, address _tkn_address, bytes _extraData) external returns (bool) {
		if (_from == 0x0 || _tkn_address != getContractAddress("nous_token_address") || _value > 0) {
			return false;
		}

		ERC20 nt = ERC20(_tkn_address);

		uint256 amount = nt.allowance(_from, this); // how many coins we are allowed to spend
		if (amount >= _value) {
			if (nt.transferFrom(_from, this, _value)) {
				return FundInterface(DOUG).bayTokens(_from, _value);
			}
		}
		return false;
	}

	/*function execute(bytes32 actionName, bytes data) returns(bool) {
		if (locked == true) return false;
		uint8 perm_level = actionPermission[actionName];
		address actionDb = getContractAddress();
	}*/

}