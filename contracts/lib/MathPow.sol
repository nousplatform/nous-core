pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/math/SafeMath.sol";


library MathPow {

    using SafeMath for uint256;

    function calculatePercent(
        uint256 _value,
        uint256 _percent
    )
    public
    pure
    returns(uint256)
    {
        return _value.mul(_percent).div(100);
    }

    function divDecimals(
        uint256 multiplier,
        uint256 numerator,
        uint256 precision
    )
    public
    pure
    returns(uint quotient)
    {
        uint _precision = 10 ** (precision);
        uint _multiplier = multiplier.mul(_precision);
        uint _quotient = (_multiplier.div(numerator)).mul(_precision);
        return (_quotient / _precision);
    }

    function percent(uint numerator, uint denominator, uint precision)
    public
    pure
    returns(uint quotient)
    {
        // caution, check safe-to-multiply here
        uint _numerator  = numerator.mul(10 ** (precision.add(1)));
        // with rounding of last digit
        uint _quotient =  ((_numerator.div(denominator)).add(5)).div(10);
        return ( _quotient);
    }
}
