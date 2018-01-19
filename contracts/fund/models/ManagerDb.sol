pragma solidity ^0.4.18;


import "../interfaces/ContractProvider.sol";
import "../interfaces/Construct.sol";
import "../base/FundManagerEnabled.sol";


contract ManagerDb is FundManagerEnabled, Construct {

    struct ManagerStruct {
        bytes32 firstname;
        bytes32 lastname;
        bytes32 email;
        uint index;
    }

    mapping (address => ManagerStruct) public managers;

    address[] public managerIndex; // Managers

    function insertManager(
        address _managerAddress,
        bytes32 _firstname,
        bytes32 _lastname,
        bytes32 _email
    )
    public returns (bool)
    {
        require(!isFundManager() || !isManager(_managerAddress));

        ManagerStruct memory newManager;
        newManager._firstname = _firstname;
        newManager._lastname = _lastname;
        newManager._email = _email;
        newManager.index = managerIndex.push(_managerAddress) - 1;
        managers[_managerAddress] = newManager;

        return true;
    }

    function deleteManager(address _managerAddress) public returns (bool)
    {
        require(!isFundManager() || !isManager(_managerAddress));

        uint rowToDelete = managers[_managerAddress].index;
        address keyToMove = managerIndex[managerIndex.length - 1];
        managerIndex[rowToDelete] = keyToMove;
        managers[keyToMove].index = rowToDelete;
        managerIndex.length--;
        return true;
    }

    function getAllManagers() public constant returns (bytes32[], bytes32[], bytes32[], address[]) {
        uint length = managerIndex.length;
        bytes32[] memory firstname = new bytes32[](length);
        bytes32[] memory lastname = new bytes32[](length);
        bytes32[] memory email = new bytes32[](length);
        address[] memory addrs = new address[](length);
        for (uint i = 0; i < managerIndex.length; i++) {
            ManagerStruct memory ms = managers[managerIndex[i]];
            firstname[i] = ms.firstname;
            lastname[i] = ms.lastname;
            email[i] = ms.email;
            addrs[i] = managerIndex[i];
        }
        return (firstname, lastname, email, addrs);
    }

    function isManager(address managerAddress) internal constant returns (bool isIndeed) {
        if (managerIndex.length == 0) return false;
        return managerIndex[managers[managerAddress].index] == managerAddress;
    }

}
