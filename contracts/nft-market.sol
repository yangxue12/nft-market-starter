// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Market{
    IERC20 public erc20;
    IERC721 public erc721;

    struct Order{
        address seller;
        uint256 tokenId;
        uint256 price;
    }

    mapping(uint256 => Order) public orderOfId;
    Order[] public orders;
    mapping(uint256 => uint256) public idToOrderIndex;

    event Deal(address seller, address buyer, uint256 tokenId,uint256 price);
    event NewOrder(address seller,uint256 tokenId,uint256 price);
    event PriceChanged(address seller, uint256 tokenId,uint256 previousPrice, uint256 price);
    event OrderCancelled(address seller,uint256 tokenId);

    constructor(address _erc20, address _erc721){
        required(_erc20!=address(0),"zero address");
        required(_erc721!=address(0),"zero address");
        erc20=IERC20(_erc20);
        erc721=IERC721(_erc721);
    }

    function buy(uint256 _tokenId) external{
        address seller=orderOfId[_tokenId].seller;
        address buyer=msg.sender;
        uint256 price=orderOfId[_tokenId].price;

        required(erc20.transferFrom(buyer,seller,price),"transfer not successful');
        erc721.safeTransferFrom(address(this),buyer,_tokenId);
        emit Deal(seller,buyer,_tokenId,price);
    
    }
}