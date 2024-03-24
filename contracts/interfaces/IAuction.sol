// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuctionFacet {
    event AuctionOpened(uint256 indexed tokenId, address indexed NFTAddress, address indexed seller);
    event BidPlaced(uint256 indexed tokenId, address indexed seller, address indexed bidder, uint256 bidPrice);

    function AuctionNFT(uint256 _tokenId, address _NFTAddress) external;
    function bidNFT(uint256 _tokenId, uint256 _bidPrice) external payable;
    function isOutBidded(address _currentBidder) external returns (bool);
    function viewBids() external view returns (address[] memory);
}
