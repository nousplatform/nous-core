pragma solidity ^0.4.18;


import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import {SnapshotDbInterface as SnapshotDb} from "../models/SnapshotDb.sol";
import {OpenEndedSaleDbInterface as OpenEndedSaleDb} from "../models/OpenEndedSaleDb.sol";
import {Validee} from "../../doug/safety/Validee.sol";


contract BaseSaleOpenEnded is Validee, AllowPurchases {

    using SafeMath for uint256;

    string public name;

    string public symbol;

    uint8 public decimals;

    address wallet;

    address nousWallet;

    uint256 public constant EXPONENT = 10 ** uint256(decimals);

    // @dev constructor
    // @param element address _wallet
    constructor (address _wallet)
    public
    {
        wallet = _wallet;
    }

    function rate()
    public
    view
    returns (uint)
    {
        address _sdb = getContractAddress("SnapshotDb");
        uint _rate = SnapshotDb(_sdb).rate();
        if (_rate == 0) {
            _rate = getDataParamsSaleDb("initPrice");
        }
        require(_rate > 0);
        return _rate;
    }

    function getDataParamsSaleDb(bytes32 _rowName)
    public
    view
    returns (uint256)
    {
        address _sdb = getContractAddress("OpenEndedSaleDb");
        return OpenEndedSaleDb(_sdb).params(_rowName);
    }

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
