pragma solidity ^0.4.4;


library Utils {

    function emptyStringTest(string emptyStringTest) internal constant returns (bool) {
        bytes memory tempEmptyStringTest = bytes(emptyStringTest); // Uses memory
        if (tempEmptyStringTest.length == 0) {
            return false;
        }
        return true;
    }

    function stringToBytes32(string memory source) returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

}
