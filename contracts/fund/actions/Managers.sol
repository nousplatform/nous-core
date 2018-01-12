pragma solidity ^0.4.18;


import "./Permission.sol";
import "../interfaces/ManagerProvider.sol";
import "../../lib/Validator.sol";


contract Managers is Permission {

    //@dev Managers actions
    function addManager(address managerAddress, bytes32 firstName, bytes32 lastName, bytes32 email) external returns (bool) {
        require(!checkPermission("owner"));
        require(managerAddress != 0x0);
        require(firstName.length > 0);
        require(lastName.length > 0);
        require(email.length > 0);

        address managerdb = getContractAddress("manager_db");
        return ManagerProvider(managerdb).insertManager(managerAddress, firstName, lastName, email);
    }

    function delManager(address managerAddress) external returns (bool) {
        require(!checkPermission("owner"));
        require(managerAddress != 0x0);

        address managerdb = getContractAddress("manager_db");
        return  ManagerProvider(managerdb).deleteManager(managerAddress);
    }

}
