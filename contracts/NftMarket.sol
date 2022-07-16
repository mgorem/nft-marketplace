// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; // security control to prevents rentry attacks from multiple requests or transactions

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds; // each individual market item created
    Counters.Counter private _itemsSold;

    address payable owner;
    uint256 listingPrice = 0.025 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    //keeping track of items created through passing their ids and storing marketItem information
    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketPlaceCreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    // function to get the lising price
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    // functions to interact with the contract

    // function to create market item and put it for sale
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price > 0, "Price must be at least 1 Wei");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        // passing the token to the contract to send it to the msg.sender of the new buyer
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        // fire the event we initialized earlier
        emit MarketPlaceCreated(
        itemId,
        nftContract,
        tokenId,
        msg.sender,
        address owner,
        address(0),
        false
    );
    } // consists of a public non-reentrant module to prevent reentry attacks

    // function to create a market sale for buying and selling an item between parties
    function createMarketSale(
        address nftContract,
        uint256 itemId
    ) public payable nonReentrant {
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;
        require(msg.value = price, "Please submit the asking price in order to complete the purchase");

        idToMarketItem[itemId].seller.transfer(msg.value); // send money to the seller of the digital asset
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId); // send the digital asset to the buyer
        idToMarketItem[itemId].owner = payable(msg.sender); // change the owner to the address of who has paid
        idToMarketItem[item].sold = true; // mark the boolean of status to sold
        _itemsSold.increment(); // increment the number of items sold
        payable(owner).transfer(listingPrice); // send amount paid to the seller
    }

}
