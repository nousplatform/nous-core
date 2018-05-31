pragma solidity ^0.4.18;


import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import {SnapshotDbInterface as SnapshotDb} from "../models/SnapshotDb.sol";
import {OpenEndedSaleDbInterface as OpenEndedSaleDb} from "../models/OpenEndedSaleDb.sol";
import {Validee} from "../../doug/safety/Validee.sol";


contract BaseSaleOpenEnded is Validee, AllowPurchases {

    using SafeMath for uint256;

    address wallet;

    address nousWallet;

    uint256 public constant EXPONENT = 10 ** uint256(18);

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
    returns (uint quotient)
    {
        uint decimals = 10 ** (precision);
        uint _multiplier = multiplier.mul(decimals);
        uint _quotient = (_multiplier.div(numerator)).mul(decimals);
        return (_quotient / _precision);
    }

}
