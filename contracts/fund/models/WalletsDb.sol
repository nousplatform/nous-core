pragma solidity ^0.4.4;


import "../security/DougEnabled.sol";
import "../interfaces/ContractProvider.sol";

contract WalletsDb is DougEnabled {

    struct Snapshot {
        uint balance; // current balance
        uint index; // time in snapshot
    }

    struct Wallets {
        bytes32 type_wallet;
        bool confirmed;
        uint index;
        mapping ( uint => Snapshot ) snapshot; // timestamp to structures
    }

    //mapping (uint32 => uint) snapshotMap; //
    uint[] snapshotIndex; // format YYYYMMDD

    mapping ( address => Wallets ) private wallets;
    address[] private walletsIndex;

    function WalletsDB(){
        setDougAddress(msg.sender);
    }

	// validate did the request from wallets contract
    function isFromWallet() returns (bool){
        if(DOUG != 0x0 && msg.sender == ContractProvider(DOUG).contracts("wallets")){
            return true;
        }
        return false;
    }

	// validate if wallet exists
    function isWallet(address walletAddress)
        public
        returns(bool isIndeed)
    {
        if (walletsIndex.length == 0 ) return false;
        return walletsIndex[wallets[walletAddress].index] == walletAddress;
    }

	// Add new wallet
    function insertWallet(bytes32 type_wallet, address walletAddress) returns (bool)
    {
        if (!isFromWallet() || !isWallet(walletAddress)) return false;

        Wallets memory newWallet;

        newWallet.type_wallet = type_wallet;
        newWallet.confirmed = false;
        newWallet.index = walletsIndex.push(walletAddress) - 1;

        wallets[walletAddress] = newWallet;

        return true;
    }

	// confirm wallet
    function confirmWallet(address walletAddress) returns (bool){
        if (!isFromWallet() || !isWallet(walletAddress)) return false;
        wallets[walletAddress].confirmed = true;

        return true;
    }

    function addSnapshot(address walletAddress, uint balance) returns (bool){
    	uint timestamp = block.timestamp;
    	Snapshot memory newSnapshot;
    	newSnapshot.balance = balance;

    	newSnapshot.index = snapshotIndex.push(timestamp) - 1;
    	wallets[walletAddress].snapshot[timestamp] = newSnapshot;
    }

    function getSnapshot(address walletAddress, uint dateStart, uint countFrom)
    	constant returns (uint[] timestamps, uint[] balances)
	{
		timestamps = new uint[](countFrom);
		balances = new uint[](countFrom);
		uint item = 0;
		Wallets wallet = wallets[walletAddress];
		for (uint i = 0; i <= snapshotIndex.length && item >= countFrom; i++) {
			if (snapshotIndex[i] >= dateStart) {
				balances[item] = wallet.snapshot[snapshotIndex[i]].balance;
				timestamps[item] = snapshotIndex[i];
				item += 1;
			}
		}
		return (timestamps, balances);
	}
}