pragma solidity ^0.4.19;

import "./ownable.sol";

contract CreateUser is Ownable {

    struct User {
        address id;
        string userName;
        uint32 wins;
        uint32 losses;
    }

    User[] public users;

    mapping (uint => address) public userIdToAddress;

    function _createUser(address _walletAddress, string _userName) public {
        require(msg.sender == _walletAddress, "You must be connected to the wallet address you're using to sign up");
        uint id = users.push(User(_walletAddress, _userName, 0, 0));
        userIdToAddress[id] = _walletAddress;
    }
}