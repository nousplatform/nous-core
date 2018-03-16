pragma solidity ^0.4.18;


library Utils {

    function emptyStringTest(string _emptyStringTest) internal constant returns (bool) {
        bytes memory tempEmptyStringTest = bytes(_emptyStringTest); // Uses memory
        if (tempEmptyStringTest.length == 0) {
            return false;
        }
        return true;
    }

    function stringToBytes32(string memory _source) returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(_source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(_source, 32))
        }
    }

}
