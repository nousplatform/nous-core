pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract TGESchedule is Ownable {

    using SafeMath for uint256;

    // bonus discount
    enum TypeBonus {Bonus, Discount}

    struct BetwinPricingRateStruct {
        uint256 minPrice;
        uint256 maxPrice;
        uint256 bonusRate; // percent for bonus
    }

    struct BonusStruct {
        uint256 startTimestamp; // in week rate
        uint256 endTimestamp; // in week rate
        TypeBonus _type;
        mapping(uint256 => BetwinPricingRateStruct) bonuses;
        uint256[] indexBonus;
    }

    BonusStruct[] public bonuses;

    function setBonus(uint256 _startTimestamp, uint256 _endTimestamp, TypeBonus _type) public onlyOwner returns(uint256) {
        require(_endTimestamp < _startTimestamp);

        BonusStruct memory newBonusStruct;
        newBonusStruct.startTimestamp = _startTimestamp;
        newBonusStruct.endTimestamp = _endTimestamp;
        newBonusStruct._type = _type;
        return bonuses.push(newBonusStruct);
    }

    function addUpdateBonusPricing(uint256 _bonusID, uint256 _priceRateID, uint256 _minPrice, uint256 _maxPrice, uint256 _bonusRate)
    public onlyOwner returns(bool) {
        require(_bonusID > 0);
        require(_minPrice < _maxPrice);
        require(_bonusRate > 0);
        BetwinPricingRateStruct memory _priceRate;

        // if price rate id is 0 then create new price perid
        if (_priceRateID == 0) {
            // add last element
            _priceRate = bonuses[_bonusID-1].bonuses[bonuses[_bonusID-1].indexBonus.length];
        } else {
            _priceRate = bonuses[_bonusID-1].bonuses[_priceRateID-1];
        }

        _priceRate.minPrice = _minPrice;
        _priceRate.maxPrice = _maxPrice;
        _priceRate.bonusRate = _bonusRate;
        return true;
    }

    /**
    * @dev _amount in mul Exponents
    * @param _amount amount tokens Note is big int multiplay to EXPONENT
    * @param _rate Rate for token
    */
    function getBonusRate(uint256 _amount, uint256 _rate) public returns(uint256) {
        uint256 totalAmount = _amount.mul(_rate);
        for (uint256 i = 0; i < bonuses.length; i++) {
            if (now < bonuses[i].endTimestamp && now > bonuses[i].startTimestamp) {
                for (uint256 j; j < bonuses[i].bonus.length; j++) {
                    if (_amount >= bonuses[i].bonus[j].minPrice && _amount < bonuses[i].bonus[j].maxPrice) {
                        if (bonuses[i]._type == TypeBonus.Bonus) {
                            totalAmount = totalAmount.add(totalAmount.mul(bonuses[i].bonus[j].bonusRate).div(100));
                        } else {
                // скидка высчитывается из rate, потом прибавляется к основному рейту
                // при этом при высчитывании процента не делиться на 100 так как все числа целые и недопустимы дробные
                // так же рейт тоже умножаеться на 100. После _amount умножаеться на новый рейт и делиться на 100
                            uint256 percent = _rate.mul(bonuses[i].bonus[j].bonusRate); // не делим на 100
                            totalAmount = _amount.mul(_rate.mul(100).add(percent)).div(100);
                        }
                    }
                }
            }
        }
        return totalAmount;
    }

    function getAllPeriodsBonuses() public constant
    returns(uint256[] memory _startTimestamps, uint256[] memory _endTimestamps, TypeBonus[] memory _types, uint256[] _ids) {
        uint256 _length =  bonuses.length;
        _startTimestamps = new uint256[](_length);
        _endTimestamps = new uint256[](_length);
        _types = new TypeBonus[](_length);
        _ids = new uint256[](_length);
        for (uint i = 0; i < _length; i++) {
            _startTimestamps[i] = bonuses[i].startTimestamp;
            _endTimestamps[i] = bonuses[i].endTimestamp;
            _types[i] = bonuses[i]._type;
            _ids[i] = i+1;
        }
        return (_startTimestamps, _endTimestamps, _types, _ids);
    }

    /*
    * @dev Note periodID must be not null
    */
    function getAllBonusesForPeriod(uint256 periodID) public constant
    returns (uint256[] memory _minPrices, uint256[] memory _maxPrices, uint256[] memory _bonusRates) {
        uint256 _length =  bonuses[periodID-1].bonus.length;
        _minPrices = new uint256[](_length);
        _maxPrices = new uint256[](_length);
        _bonusRates = new uint256[](_length);
        for (uint i = 0; i < _length; i++) {
            _minPrices[i] = bonuses[periodID-1].bonus[i].minPrice;
            _maxPrices[i] = bonuses[periodID-1].bonus[i].maxPrice;
            _bonusRates[i] = bonuses[periodID-1].bonus[i].bonusRate;
        }
        return (_minPrices, _maxPrices, _bonusRates);
    }
}
