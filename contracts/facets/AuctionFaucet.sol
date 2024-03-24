// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { LibAppStorage } from "../libraries/LibAppStorage";
import IERC721 from "../interfaces/IERC721";
import IERC20 from "../interfaces/IERC20";



contract AuctionFaucet {

    LibAppStorage.Layout internal l;
   
    event AuctionOpened(uint256 tokenId, address NFTAddress, address seller);
    event BidClosed(uint256 tokenId, address NFTAddress, address highestBidder);

    function AuctionNFT(uint256 _tokenId, address _NFTAddress) external {
        IERC721 erc721 = _NFTAddress;
        l.tokenId = _tokenId;
        require(
            erc721.ownerOf(_tokenId) == msg.sender,
            "Only the owner can offer the NFT"
        );        
      
        l.availableBids[msg.sender].push(_NFTAddress);

        emit AuctionOpened(_tokenId, msg.sender);
    }

    // Buy NFT
    function bidNFT(uint256 _tokenId, uint256 _bidPrice) external payable {
        l.biddingprice = _bidPrice;
        require(l.!isClosed[_tokenId], "This Auction is closed");
        require(_bidPrice >= l.currentPrice * 2, "You need to bid higher to outbid the last guy");        
        require(msg.value >= _bidPrice, "Insufficient funds");

        l.currentPrice = _bidPrice;

        IERC20(transfer(address(this), _bidPrice));
        if(block.timestamp - l.auctionOpenTime >= l.TIME) {
            IERC721(transferFrom(l.NFTowner(_tokenId), msg.sender, _tokenId))
            l.isClosed[_tokenId] = true;
        }
        l.isClosed = false;           

        emit BidPlaced(_tokenId, seller, msg.sender, _bidPrice);
    }


    function isOUtBidded(address _currentBidder) external returns (bool){
        if(l.biddingprice > l.currentPrice * (currentPrice*1/5)) {
            l.isOutBidded[l.tokenId][_currentBidder] = true;
            uint256 extraTax = (calculateTax(l.biddingprice)) * 3/10
            IERC20(transferFrom(address(this), _currentBidder, l.currentPrice + extraTax));
        
        l.isOutBidded[l.tokenId][_currentBidder] = false;


    }

    function calculateTax(uint256 _bidAmount) internal {
        _bidAmount - (_bidAmount * 1/10);   
        
    }

    // See NFTs on offer
    function viewBids(
    ) external view returns (address [] storage) {       
        return l.availableBids;
    }

}

 

