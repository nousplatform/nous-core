pragma solidity ^0.4.18;


contract ActionManagerInterface {
    function lock() returns (bool);
    function unlock() returns (bool);
}
