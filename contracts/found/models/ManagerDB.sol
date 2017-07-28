pragma solidity ^0.4.0;

contract ManagerDB {

    struct ManagerStruct {
        bytes32 firstname;
        bytes32 lastname;
        uint index;
    }

    mapping ( address => ManagerStruct ) private ManagerStructs;
    address[] private managerIndex; // Managers

    function ManagerDB(){

    }

    function isManager(address _managerAddress)
        public
        constant
        returns(bool isIndeed)
    {
        if (managerIndex.length == 0 ) return false;
        return managerIndex[ManagerStructs[_managerAddress].index] == _managerAddress;
    }

    /*CRUD*/
    function insertManager(
        address _managerAddress,
        bytes32 _firstName,
        bytes32 _lastName,
        bytes32 _email
    )
        //onlyOwner()
        public
        returns(uint index)
    {
        if (isManager(_managerAddress)) revert();

        ManagerStruct newManager;
        newManager.firstname = _firstName;
        newManager.lastname = _lastName;
        newManager.index = managerIndex.push(_managerAddress)-1;

        ManagerStructs[_managerAddress] = newManager;
        return managerIndex.length - 1;
    }

    function deleteManager(address _managerAddress)
        //onlyOwner()
        public
        returns(uint index)
    {
        uint rowToDelete = ManagerStructs[_managerAddress].index; // index manager to de
        address keyToMove = managerIndex[managerIndex.length-1];
        managerIndex[rowToDelete] = keyToMove;
        ManagerStructs[keyToMove].index = rowToDelete;
        managerIndex.length--;

        /*LogDeleteManager(
            _managerAddress,
            rowToDelete);*/
        /*LogUpdateUser(
            keyToMove,
            rowToDelete,
            userStructs[keyToMove].userEmail,
            userStructs[keyToMove].userAge);*/

        return rowToDelete;
    }
}
