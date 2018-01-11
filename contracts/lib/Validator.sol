pragma solidity ^0.4.4;


library Validator {

    function emptyStringTest(string emptyStringTest)  internal constant returns (bool) {
        bytes memory tempEmptyStringTest = bytes(emptyStringTest); // Uses memory
        if (tempEmptyStringTest.length == 0) {
            return false;
        }
        return true;
    }
}
