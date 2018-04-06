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
        uint256 bonusRatePercent; // percent for bonus
    }

    struct BonusStruct {
        uint256 startTimestamp; // in week rate
        uint256 endTimestamp; // in week rate
        TypeBonus _type;
        mapping(uint256 => BetwinPricingRateStruct) priceBonus;
        uint256[] indexBonus;
        bool exists;
    }

    BonusStruct[] public bonuses;

    /**
    * @dev add bonuses
    * @param _startTimestamp : timestamp : start time bonus
    * @param _endTimestamp : timestamp : end time bonus
    * @param _type : 0|1 : Type bonus {Bonus, Discount}
    */
    function addBonus(uint256 _startTimestamp, uint256 _endTimestamp, TypeBonus _type)
    external onlyOwner returns(uint256) {
        require(_startTimestamp < _endTimestamp);
        BonusStruct memory newBonusStruct;
        newBonusStruct.startTimestamp = _startTimestamp;
        newBonusStruct.endTimestamp = _endTimestamp;
        newBonusStruct._type = _type;
        newBonusStruct.exists = true;
        return bonuses.push(newBonusStruct);
    }

    function updateBonus(uint256 _id, uint256 _startTimestamp, uint256 _endTimestamp, TypeBonus _type)
    external onlyOwner returns(bool) {
        require(_startTimestamp < _endTimestamp);
        uint256 _i = _id - 1;
        require(bonuses[_i].exists);

        bonuses[_i].startTimestamp = _startTimestamp;
        bonuses[_i].endTimestamp = _endTimestamp;
        bonuses[_i]._type = _type;
    }

    function deleteBonus(uint256 _id) external onlyOwner returns(bool) {
        uint256 _i = _id - 1;
        require(bonuses[_i].exists);
        BonusStruct memory replacement = bonuses[bonuses.length - 1];
        bonuses[_i] = replacement;
        bonuses.length -= 1;
        return true;
    }

    function addUpdateBonusPricing(uint256 _bonusID, uint256 _priceRateID, uint256 _minPrice, uint256 _maxPrice, uint256 _bonusRatePercent)
    external onlyOwner returns(bool) {
        uint256 _bonusIndex = _bonusID - 1; // index
        require(bonuses[_bonusIndex].exists);
        require(_minPrice < _maxPrice);
        require(_bonusRatePercent > 0);

        uint256 _i;

        // if price rate id is 0 then create new price perid
        if (_priceRateID == 0) {
            if (bonuses[_bonusIndex].indexBonus.length > 0) {
                _i = bonuses[_bonusIndex].indexBonus.length;
            } else {
                _i = 0;
            }
            bonuses[_bonusIndex].indexBonus.push(_i);
        } else {
            _i = _priceRateID - 1;
        }

        bonuses[_bonusIndex].priceBonus[_i].minPrice = _minPrice;
        bonuses[_bonusIndex].priceBonus[_i].maxPrice = _maxPrice;
        bonuses[_bonusIndex].priceBonus[_i].bonusRatePercent = _bonusRatePercent;
        return true;
    }

    /**
    * @dev for tests, returns current rate amount
    */
    function testGetBonusRate(uint256 _amount, uint256 _rate) external constant returns (uint256) {
        return getBonusRate(_amount, _rate);
    }

    /**
    * @dev _amount in mul Exponents
    * @param _amount amount tokens Note is big int multiplay to EXPONENT
    * @param _rate Rate for token
    */
    function getBonusRate(uint256 _amount, uint256 _rate) public returns(uint256) {
        uint256 totalAmount = _amount.mul(_rate);
        for (uint256 i = 0; i < bonuses.length; i++) {
            if (now > bonuses[i].startTimestamp && now < bonuses[i].endTimestamp) {
                for (uint256 j; j < bonuses[i].indexBonus.length; j++) {
                    if (_amount >= bonuses[i].priceBonus[j].minPrice && _amount < bonuses[i].priceBonus[j].maxPrice) {
                        if (bonuses[i]._type == TypeBonus.Bonus) {
                            totalAmount = totalAmount.add(totalAmount.mul(bonuses[i].priceBonus[j].bonusRatePercent).div(100)); // todo умножить на 100
                        } else {
                // скидка высчитывается из rate, потом прибавляется к основному рейту
                // при этом при высчитывании процента не делиться на 100 так как все числа целые и недопустимы дробные
                // так же рейт тоже умножаеться на 100. После _amount умножаеться на новый рейт и делиться на 100
                            uint256 percent = _rate.mul(bonuses[i].priceBonus[j].bonusRatePercent); // не делим на 100
                            totalAmount = _amount.mul(_rate.mul(100).add(percent)).div(100);
                        }
                    }
                }
            }
        }
        return totalAmount;
    }

    function getAllPeriodsBonuses() public view
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
            _ids[i] = i + 1;
        }
        return (_startTimestamps, _endTimestamps, _types, _ids);
    }

    /*
    * @dev Note periodID must be not null
    */
    function getAllBonusesForPeriod(uint256 _periodID) public constant
    returns (uint256[] memory _minPrices, uint256[] memory _maxPrices, uint256[] memory _bonusRatePercents) {
        uint256 _periodIndex = _periodID - 1; // index
        require(bonuses[_periodIndex].exists);

        uint256 _length =  bonuses[_periodIndex].indexBonus.length;
        _minPrices = new uint256[](_length);
        _maxPrices = new uint256[](_length);
        _bonusRatePercents = new uint256[](_length);
        for (uint i = 0; i < _length; i++) {
            _minPrices[i] = bonuses[_periodIndex].priceBonus[i].minPrice;
            _maxPrices[i] = bonuses[_periodIndex].priceBonus[i].maxPrice;
            _bonusRatePercents[i] = bonuses[_periodIndex].priceBonus[i].bonusRatePercent;
        }
        return (_minPrices, _maxPrices, _bonusRatePercents);
    }
}
