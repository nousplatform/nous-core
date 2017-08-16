pragma solidity ^0.4.0;

contract InvestorsDB {

    struct InvestorStruct {
        bytes32 name;
        int32 deposit;
        uint index;
    }

    mapping( address => InvestorStruct ) private investors;
    address[] private investorsIndex;


    address owner;


    function InvestorsDB(){
        this.owner = msg.sender;
    }

    function setOwner(address newOwner) constant returns (bool res)
    {
        if (owner != 0x0 && msg.sender != owner)
        {
            return false;
        }
        owner = newOwner;
        return true;
    }

    function isInvestor(address _investorAddress)
        public
        constant
        returns(bool isIndeed)
    {
        if (managerIndex.length == 0 ) return false;
        return investorsIndex[investors[_investorAddress].index] == _investorAddress;
    }

    /*CRUD*/
    function insertInvestor(
        address _investorAddress,
        bytes32 _name,
        int32 _deposit,
        uint _index
        )
        //onlyOwner()
        public
        returns(uint index)
    {
        if (isInvestor(_investorAddress)) revert();

        InvestorStruct newInvestor;
        newInvestor.name = _name;
        newInvestor.deposit = _deposit;
        newInvestor.index = investors.push(_investorAddress)-1;

        investors[_investorAddress] = newInvestor;
        return investorsIndex.length - 1;
    }

    function deleteInvestor(address _investorAddress)
        //onlyOwner()
    public
    returns(uint index)
    {
        uint rowToDelete = investors[_investorAddress].index; // index investor to del
        address keyToMove = investorsIndex[investorsIndex.length-1];
        investorsIndex[rowToDelete] = keyToMove;
        investors[keyToMove].index = rowToDelete;
        investorsIndex.length--;

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