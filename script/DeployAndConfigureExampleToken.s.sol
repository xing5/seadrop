// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";

import { ERC721SeaDrop } from "../src/ERC721SeaDrop.sol";

import { ISeaDrop } from "../src/interfaces/ISeaDrop.sol";

import { PublicDrop } from "../src/lib/SeaDropStructs.sol";

contract DeployAndConfigureExampleToken is Script {
    // Addresses
    address seadrop = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;
    address creator = 0x0190f8Ea0234fa3C4d3121F6d13DA3d7c9770fAC;
    address feeRecipient = 0x0190f8Ea0234fa3C4d3121F6d13DA3d7c9770fAC;

    // Token config
    uint256 maxSupply = 100;

    // Drop config
    uint16 feeBps = 500; // 5%
    uint80 mintPrice = 0.2 ether;
    uint16 maxTotalMintableByWallet = 1000;
    uint48 constant ONE_MONTH = 30 days; 

    function run() external {
        vm.startBroadcast();

        address[] memory allowedSeadrop = new address[](1);
        allowedSeadrop[0] = seadrop;

        ERC721SeaDrop token = new ERC721SeaDrop(
            "Wukong Headband",
            "WKHB",
            allowedSeadrop
        );

        // Configure the token.
        token.setMaxSupply(maxSupply);

        // Configure the drop parameters.
        token.updateCreatorPayoutAddress(seadrop, creator);
        token.updateAllowedFeeRecipient(seadrop, feeRecipient, true);
        token.updatePublicDrop(
            seadrop,
            PublicDrop(
                mintPrice,
                uint48(block.timestamp), // start time
                uint48(block.timestamp) + ONE_MONTH, // end time
                maxTotalMintableByWallet,
                feeBps,
                true
            )
        );

        token.ownerMint(creator, 10);

        // We are ready, let's mint the first 3 tokens!
        // ISeaDrop(seadrop).mintPublic{ value: mintPrice * 3 }(
        //     address(token),
        //     feeRecipient,
        //     address(0),
        //     3 // quantity
        // );
    }
}
