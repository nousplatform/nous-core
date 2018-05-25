pragma solidity ^0.4.21;


import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";


/**
 * @title Mintable token
 * @ dev only for open ended fund
 */
contract SimpleMintableToken is StandardToken {

    event Mint(address indexed to, uint256 amount);

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint256 _amount) internal returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

}
