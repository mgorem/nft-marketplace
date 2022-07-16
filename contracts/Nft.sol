// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // ERC721 standard
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // Extensio for ERC721 storage to set the token URI
import "@openzeppelin/contracts/utils/Counters.sol"; // Utility for incrementing numbers

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter; // use Counters utility to declare a variable that  creates tokenIds
    Counters.Counter private _tokenIds;
    address contractAddress; // address of the marketplace that we want to allow the nft to be able to interact with or vice versa.

    constructor(address marketPlaceAddress) ERC721("Slimdex Tokens", "SDX") {
        contractAddress = marketPlaceAddress;
    }

    function createToken(string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}
