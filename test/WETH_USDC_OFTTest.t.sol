// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import { ILayerZeroEndpointV2 } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { BaseOFTTest, IOFTWithRate } from "./BaseOFTTests.t.sol";


// To run tests on ETH: forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/Y41Zvm9c8RIq6Ld4ohvI0yFL_Zl9xvf5  --mc WethUSDCOFTTest

contract WethUSDCOFTTest is BaseOFTTest {
    address public OFT_ADDRESS = 0xfcff5015627B8ce9CeAA7F5b38a6679F65fE39a7;

    function setUp() public override {
        super.setUp();
        address[] memory requiredDvnsEth = new address[](2);
        requiredDvnsEth[0] = LZ_DVN_ETH;
        requiredDvnsEth[1] = CANARY_DVN_ETH;

        address[] memory optionalDvnsEth = new address[](2);

        networkValues[ETH_EID] = NetworkValues({
            oft: IOFTWithRate(OFT_ADDRESS),
            sendLib: SEND_LIB_ETH,
            receiveLib: RECEIVE_LIB_ETH,
            dvns: requiredDvnsEth,
            optionalDvns: optionalDvnsEth,
            optionalDvnThreshold: 3,
            executor: EXECUTOR_ETH,
            confirmations: FROM_ETH_CONFIRMATIONS,
            endpoint: ILayerZeroEndpointV2(ENDPOINT_ETH),
            token: IERC20Metadata(OFT_ADDRESS),
            safe: SAFE_ETH
        });

        currentEid = chainIdToEid[block.chainid];
        networkConfig = networkValues[currentEid];

        if (block.chainid == ETH_CHAIN_ID) {
            sendingSrcEid = ARB_EID;
            sendingDstEid = ARB_EID;
            oftSender = OFT_ADDRESS;
        }
    }
}
