// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibAppStorage} from "../libraries/LibAppStorage.sol";

contract ERC721Facet {
    LibAppStorage.Layout internal l;
    
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return l.ownerTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address owner) {
        owner = l.NFTowner[_tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        safeTransferFrom(_from, _to, _tokenId);
    }

    // function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
    //     transferFrom(_from, _to, _tokenId);
    //     // require(_checkOnERC721Received(_from, _to, _tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    // }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        address owner = l.NFTowner[_tokenId];
        require(_from == owner, "ERC721: transfer of token that is not own");
        require(_to != address(0), "ERC721: transfer to the zero address");

        _clearApproval(_from, _tokenId);
        _removeTokenFrom(_from, _tokenId);
        _addTokenTo(_to, _tokenId);

        emit Transfer(_from, _to, _tokenId);
    }

    // function approve(address _approved, uint256 _tokenId) public {
    //     address owner = l.NFTowner[_tokenId];
    //     require(_approved != owner, "ERC721: approval to current owner");
    //     require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all");

    //     l.tokenIdToApproved[_tokenId] = _approved;
    //     emit Approval(owner, _approved, _tokenId);
    // }

    // function setApprovalForAll(address _operator, bool _approved) public {
    //     l.ownerToOperators[msg.sender][_operator] = _approved;
    //     emit ApprovalForAll(msg.sender, _operator, _approved);
    // }

    // function getApproved(uint256 _tokenId) public view returns (address) {
    //     require(_exists(_tokenId), "ERC721: approved query for nonexistent token");

    //     return l.tokenIdToApproved[_tokenId];
    // }

    // function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
    //     return l.ownerToOperators[_owner][_operator];
    // }

    function _exists(uint256 _tokenId) internal view returns (bool) {
        return l.NFTowner[_tokenId] != address(0);
    }

    function _clearApproval(address _owner, uint256 _tokenId) internal {
        delete l.tokenIdToApproved[_tokenId];
        emit Approval(_owner, address(0), _tokenId);
    }

    function _removeTokenFrom(address _from, uint256 _tokenId) internal {
        require(l.NFTowner[_tokenId] == _from, "ERC721: transfer of token that is not own");
        l.ownerTokenCount[_from]--;
        delete l.NFTowner[_tokenId];
    }

    function _addTokenTo(address _to, uint256 _tokenId) internal {
        require(l.NFTowner[_tokenId] == address(0), "ERC721: token already has an owner");
        l.ownerTokenCount[_to]++;
        l.NFTowner[_tokenId] = _to;
    }

    // function _checkOnERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
    //     if (!_to.isContract()) {
    //         return true;
    //     }
    //     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
    //     return (retval == ERC721_TOKEN_RECEIVED);
    // }

    function mint(address _to, uint256 _tokenId) external {
        LibDiamond.enforceIsContractOwner();
        require(_to != address(0), "ERC721: mint to the zero address");
        require(!_exists(_tokenId), "ERC721: token already minted");

        _addTokenTo(_to, _tokenId);
        emit Transfer(address(0), _to, _tokenId);
    }

    bytes4 private constant ERC721_TOKEN_RECEIVED = 0x150b7a02;
}

// interface ERC721TokenReceiver {
//     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
// }

// 