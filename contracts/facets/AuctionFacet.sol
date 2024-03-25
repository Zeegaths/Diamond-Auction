// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {LibAppStorage} from "../libraries/LibAppStorage.sol";
import {IERC721} from "../interfaces/IERC721.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "../interfaces/IERC20.sol";

contract AuctionFacet {
    LibAppStorage.Layout internal l;

    // IERC20 Ierc20 = l.diamondToken;

    event AuctionOpened(uint256 tokenId, address NFTAddress, address seller);
    event BidClosed(uint256 tokenId, address NFTAddress, address highestBidder);
    event BidPlaced(uint256 tokenId, address bidder, uint256 bidPrice);

    function AuctionNFT(uint256 _tokenId, address _NFTAddress) external {
        l.NFT = _NFTAddress;
        l.tokenId = _tokenId;
        require(
            IERC721(l.NFT).ownerOf(_tokenId) == msg.sender,
            "Only the owner can offer the NFT"
        );

        l.allBids.push(_NFTAddress);

        emit AuctionOpened(_tokenId, _NFTAddress, msg.sender);
    }

    // Buy NFT
    function bidNFT(uint256 _tokenId, uint256 _bidPrice) external payable {        
        
        l.biddingprice = _bidPrice;
        require(!l.isClosed[_tokenId], "This Auction is closed");
        require(
            _bidPrice >= l.currentPrice * 2,
            "You need to bid higher to outbid the last guy"
        );
        require(msg.value >= _bidPrice, "Insufficient funds");

        l.currentPrice = _bidPrice;
        l.bidders.push(msg.sender);

        IERC20(l.diamondToken).transfer(address(this), _bidPrice);
        if (block.timestamp - l.auctionOpenTime >= LibAppStorage.TIME) {
            IERC721(l.NFT).transferFrom(
                l.NFTowner[_tokenId],
                msg.sender,
                _tokenId
            );
            l.isClosed[_tokenId] = true;
        }
        l.isClosed[_tokenId] = false;

        emit BidPlaced(_tokenId, msg.sender, _bidPrice);
    }

    function isOutBidded(address _currentBidder) external returns (bool) {
        if (l.biddingprice > l.currentPrice * ((l.currentPrice * 1) / 5)) {
            l.isOutBidded[_currentBidder][l.tokenId] = true;
            uint256 extraTax = ((calculateTax(l.biddingprice)) * 3) / 10;
            IERC20(l.diamondToken).transferFrom(
                address(this),
                _currentBidder,
                l.currentPrice + extraTax
            );

            l.isOutBidded[_currentBidder][l.tokenId] = false;
            return true;
        }
        return false;
    }

    function calculateTax(uint256 _bidAmount) internal pure returns (uint256) {
        return _bidAmount - ((_bidAmount * 1) / 10);
    }

    // See NFTs on offer
    function viewBids() external view returns (address[] memory) {
        return l.allBids;
    }
}
