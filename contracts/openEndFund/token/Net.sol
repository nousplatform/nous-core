pragma solidity ^0.4.18;


import {PurchaseToken} from "./PurchaseToken.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";


contract Net is SimpleMintableToken, PurchaseToken {

    mapping (address => uint256) public fundCup;
    address[] indexTicker;

    // @dev Override mint function
    function mint(
        address _to,
        uint256 _amount
    )
    internal
    returns (bool)
    {
        if (fundCup[msg.sender] == 0) {
            indexTicker.push(msg.sender);
        }

        fundCup[msg.sender] += _amount;
        super.mint(_to, _amount);
    }

    function redeem(
        address _withdrawAddr,
        uint256 _value
    )
    public
    returns (bool)
    {
        fundCup[_withdrawAddr] -= _value;
        super.redeem(_withdrawAddr, _value);
    }
}
