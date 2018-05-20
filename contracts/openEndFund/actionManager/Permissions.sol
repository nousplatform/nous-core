pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/ownership/rbac/RBAC.sol";


contract Permissions is RBAC {

    string internal constant ROLE_FUND_OWNER = "OWNER";

    string internal constant ROLE_NOUS_PLATFORM = "NOUS";

    string internal constant ROLE_FUND_MANAGER = "MANAGER";

    modifier onlyOwner()
    {
        checkRole(msg.sender, ROLE_FUND_OWNER);
        _;
    }

    modifier orRole(string role1, string role2)
    {
        require(hasRole(msg.sender, role1) || hasRole(msg.sender, role2));
        _;
    }

    /**
     * @dev constructor. Sets msg.sender as admin by default
     */
    constructor(address fundOwner, address nousPlatform)
    public
    {
        addRole(fundOwner, ROLE_FUND_OWNER);
        addRole(nousPlatform, ROLE_NOUS_PLATFORM);
    }

    /**
     * @dev add a role to an address
     * @param addr address
     */
    function ownerAddManager(address addr)
    onlyOwner
    public
    {
        addRole(addr, ROLE_FUND_MANAGER);
    }

    /**
     * @dev remove a role from an address
     * @param addr address
     */
    function ownerRemoveManager(address addr)
    onlyOwner
    public
    {
        removeRole(addr, ROLE_FUND_MANAGER);
    }

}
