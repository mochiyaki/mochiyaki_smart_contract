// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Mochiyaki is ERC721 {
    uint256 public maxSupply;
    uint256 public totalSupply;
    address public owner;

    struct Mochi {
        string name;
        uint256 cost;
        bool isOwned;
    }

    mapping(uint256 => Mochi) mochis;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() ERC721("Mochi", "721")
    {
        owner = msg.sender;
    }

    function list(string memory _name, uint256 _cost) public onlyOwner {
        maxSupply++;
        mochis[maxSupply] = Mochi(_name, _cost, false);
    }

    function mint(uint256 _id) public payable {
        require(_id != 0);
        require(_id <= maxSupply);
        require(domains[_id].isOwned == false);
        require(msg.value >= mochis[_id].cost);
        mochis[_id].isOwned = true;
        totalSupply++;
        _safeMint(msg.sender, _id);
    }

    function getMochi(uint256 _id) public view returns (Mochi memory) {
        return mochis[_id];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getFund() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }
}