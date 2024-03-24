// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { LibAppStorage } from "../libraries/LibAppStorage";
import IERC721 from "../interfaces/IERC721";
import IERC20 from "../interfaces/IERC20";


contract AuctionFaucet {

    LibAppStorage.Layout internal l;
    //    modifier onlyOwner() {
    //     require(msg.sender == owner, "Only the owner can call this function");
    //     _;
    // }

    // Mint new NFTs
    // function mintNFT(
    //     address to,
    //     string memory tokenURI
    // ) public returns (uint256) {
    //     l.tokenId ++;
    //     uint256 newTokenId = tokenId.current();
    //     _mint(to, newTokenId);
    //     _setTokenURI(newTokenId, tokenURI);
    //     return newTokenId;
    // }

    // Add NFT to the marketplace
    event AuctionOpened(uint256 tokenId, address NFTAddress, address seller);
    event BidClosed(uint256 tokenId, address NFTAddress, address highestBidder);

    function AuctionNFT(uint256 _tokenId, address _NFTAddress) external {
        IERC721 erc721 = _NFTAddress;
        l.tokenId = _tokenId;
        require(
            erc721.ownerOf(_tokenId) == msg.sender,
            "Only the owner can offer the NFT"
        );        
      
        l.availableBids[msg.sender].push(_tokenId);

        emit AuctionOpened(_tokenId, msg.sender);
    }

    // Buy NFT
    function bidNFT(uint256 _tokenId, uint256 _bidPrice) external payable {
        l.biddingprice = _bidPrice;
        require(!isClosed[tokenId], "This Auction is closed");
        require(_bidPrice >= l.currentPrice * 2, "You need to bid higher to outbid the last guy");        
        require(msg.value >= _bidPrice, "Insufficient funds");

        l.currentPrice = _bidPrice;

        IERC20(transfer(address(this), _bidPrice) )      

        // address seller = offer.seller;
        // offers[_tokenId] = NFTOffer(address(0), 0, false);
        // IERC721.safeTransferFrom(seller, msg.sender, _tokenId);

        // payable(seller).transfer(msg.value);

        emit BidPlaced(_tokenId, seller, msg.sender, _bidPrice);
    }

    // See NFTs on offer
    function view(
        uint256 _tokenId
    ) external view returns (address, uint256, bool) {
        NFTOffer memory offer = offers[_tokenId];
        return (offer.seller, offer.price, offer.isAvailable);
    }

    // See your offered NFTs
    function getMyBids() external view returns (uint256[] memory) {
        return userTokens[msg.sender];
    }

}

 

