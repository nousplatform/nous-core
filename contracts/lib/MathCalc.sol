pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/math/SafeMath.sol";


library MathCalc {

    using SafeMath for uint256;

    function calculatePercent(
        uint256 _value,
        uint256 _percent,
        uint256 _decimals
    )
    public
    pure
    returns(uint256)
    {
        uint256 _exponent = 10 ** (_decimals + 2);
        return (_value.mul(_percent)).div(_exponent);
    }

    function calculateRedeem(
        uint256 _value,
        uint256 _percent,
        uint256 _decimals
    )
    public
    pure
    returns(uint256)
    {
        uint256 _exponent = 10 ** _decimals;
        return _value.mul(_percent).div(_exponent);
    }

    function percent(
        uint numerator,
        uint denominator,
        uint precision
    )
    public
    pure
    returns(uint quotient)
    {
        uint exponent = 10 ** (precision + 1);
        uint _numerator  = numerator.mul(exponent);
        uint _quotient =  ((_numerator.div(denominator)).add(5)).div(10);
        return ( _quotient);
    }
}
