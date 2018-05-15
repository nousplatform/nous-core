pragma solidity ^0.4.18;


import {OpenEndedToken} from "../../projects/openEndedFund/token/OpenEndedToken.sol";
contract TPLOpenEndedToken {
    function create(address _owner, address _nousToken, string _name, string _symbol /*, uint8 _decimals*/) public returns (address) {
        return new OpenEndedToken(_owner, _nousToken, _name, _symbol /*, _decimals*/);
    }
}

