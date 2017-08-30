pragma solidity ^0.4.4;

import "./ERC20.sol";

contract NousToken is ERC20 {

    string public constant name = "Nous Token";
    string public constant symbol = "NT";
    uint8 public constant decimals = 18;

    mapping (address => mapping (address => uint)) allowed;
    mapping (address => uint) balances;

    function NousToken(){
        balances[msg.sender] = 1000000;
    }

    function transferFrom(address _from, address _to, uint _value) {
        var _allowance = allowed[_from][msg.sender];

        if (_value > _allowance) throw;

        balances[_to] +=_value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint _value) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint _value) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }

    function mint() payable external {
        if (msg.value == 0) throw;

        var numTokens = msg.value;
        totalSupply += numTokens;

        balances[msg.sender] += numTokens;

        Transfer(0, msg.sender, numTokens);
    }
}