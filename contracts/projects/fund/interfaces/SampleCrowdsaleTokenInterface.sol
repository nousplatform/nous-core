pragma solidity ^0.4.18;


contract SampleCrowdsaleTokenInterface {
    function constructor(address _owner, string _name, string _symbol, uint8 _decimals) public;
    function mint(address _to, uint256 _amount) public returns (bool);
    function finishMinting() public returns (bool);
}
