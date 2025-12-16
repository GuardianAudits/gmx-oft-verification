// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { ILayerZeroEndpointV2, Origin } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { IERC20Metadata } from "@openzeppelin/contracts/interfaces/IERC20Metadata.sol";
import { OFTComposeMsgCodec } from "@layerzerolabs/oft-evm/contracts/libs/OFTComposeMsgCodec.sol";
import { OFTMsgCodec } from "@layerzerolabs/oft-evm/contracts/libs/OFTMsgCodec.sol";
import { IOFT, SendParam, OFTReceipt, OFTLimit, OFTFeeDetail } from "@layerzerolabs/oft-evm/contracts/interfaces/IOFT.sol";
import { MessagingFee } from "@layerzerolabs/oapp-evm/contracts/oapp/OAppSender.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Test } from "forge-std/Test.sol";
import { IOAppReceiver } from "@layerzerolabs/oapp-evm/contracts/oapp/interfaces/IOAppReceiver.sol";
import { ExecutorConfig } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/SendLibBase.sol";
import { Constants } from "./utils/Constants.sol";
import "forge-std/console.sol";
import "forge-std/console2.sol";


struct UlnConfig {
    uint64 confirmations;
    // we store the length of required DVNs and optional DVNs instead of using DVN.length directly to save gas
    uint8 requiredDVNCount; // 0 indicate DEFAULT, NIL_DVN_COUNT indicate NONE (to override the value of default)
    uint8 optionalDVNCount; // 0 indicate DEFAULT, NIL_DVN_COUNT indicate NONE (to override the value of default)
    uint8 optionalDVNThreshold; // (0, optionalDVNCount]
    address[] requiredDVNs; // no duplicates. sorted an an ascending order. allowed overlap with optionalDVNs
    address[] optionalDVNs; // no duplicates. sorted an an ascending order. allowed overlap with requiredDVNs
}

interface IDVN {
    function getSigners() external view returns (address[] memory);
}

interface IReceiveLib {
    function executorConfigs(address _oapp, uint32 _eid) external returns(ExecutorConfig memory);
}

interface ITransparentUpgradeableProxy {
    function admin() external view returns (address);

    function implementation() external view returns (address);

    function changeAdmin(address) external;

    function upgradeTo(address) external;

    function upgradeToAndCall(address, bytes memory) external payable;
}

interface ILayerZeroEndpointDelegateable {
    function delegates(address) external returns (address);
}

interface IERC20Blockable is IERC20Metadata {
    function isBlocked(address user) external returns (bool);
    function addToBlockedList (address _user) external;
    function removeFromBlockedList (address _user) external;
}

interface TetherMintable {
    function issue(uint256 _amount) external;
}

interface IOwnable {
    function transferOwnership(address) external;
}

interface IOFTWithRate is IOFT {
    function decimalConversionRate() external view returns (uint256);
    function msgInspector() external view returns (address);
}

contract BaseOFTTestStorage is Test, Constants {

    struct NetworkValues {
        IOFTWithRate oft;
        address sendLib;
        address receiveLib;
        address[] dvns;
        address[] optionalDvns;
        uint256 optionalDvnThreshold;
        address executor;
        uint64 confirmations;
        ILayerZeroEndpointV2 endpoint;
        IERC20Metadata token;
        address safe;
    }

    mapping(uint32 => NetworkValues) networkValues;
    mapping(uint256 => uint32) chainIdToEid;

    address alice = makeAddr("alice");

    address oftSender;
    uint32 sendingSrcEid;
    uint32 sendingDstEid;

    uint32 currentEid;

    NetworkValues networkConfig;

}

contract BaseOFTTest is BaseOFTTestStorage {

    function setUp() public virtual {
        chainIdToEid[ETH_CHAIN_ID]    = ETH_EID;
        chainIdToEid[ARB_CHAIN_ID]    = ARB_EID;
        chainIdToEid[INK_CHAIN_ID]    = INK_EID;
        chainIdToEid[BERA_CHAIN_ID]   = BERA_EID;
        chainIdToEid[FLARE_CHAIN_ID]  = FLARE_EID;
        chainIdToEid[CORN_CHAIN_ID]   = CORN_EID;
        chainIdToEid[OPT_CHAIN_ID]    = OPT_EID;
        chainIdToEid[UNI_CHAIN_ID]    = UNI_EID;
        chainIdToEid[SEI_CHAIN_ID]    = SEI_EID;
        chainIdToEid[HYPER_CHAIN_ID]  = HYPER_EID;
        chainIdToEid[PLASMA_CHAIN_ID] = PLASMA_EID;
        chainIdToEid[XLAYER_CHAIN_ID] = XLAYER_EID;
        chainIdToEid[POL_CHAIN_ID]    = POL_EID; 
        chainIdToEid[ROOT_CHAIN_ID]   = ROOT_EID;
        chainIdToEid[CONFLUX_CHAIN_ID] = CONFLUX_EID;
        chainIdToEid[MONAD_CHAIN_ID] = MONAD_EID;
        chainIdToEid[MANTLE_CHAIN_ID] = MANTLE_EID;

        currentEid = chainIdToEid[block.chainid];
    }


    function test_token_send() public {
        assertEq(networkConfig.token.balanceOf(alice), 0); // alice address balance is 0 before

        vm.startPrank(address(networkConfig.endpoint));
        (bytes memory message, ) = OFTMsgCodec.encode(OFTComposeMsgCodec.addressToBytes32(address(alice)), uint64(10_000e6), "");
        IOAppReceiver(address(networkConfig.oft)).lzReceive(Origin(sendingSrcEid, OFTComposeMsgCodec.addressToBytes32(oftSender), 0), 0, message, address(this), "");
    
        assertEq(networkConfig.token.balanceOf(alice), 10_000e18); // alice received the tokens

        vm.stopPrank();
    }

    function test_fuzz_token_send(uint256 amount, address receiver) public {
        vm.assume(receiver != address(0));
        vm.assume(receiver != address(networkConfig.token));
        amount = amount % (1_000_000_000 * 1e6); // In Shared decimals (6 decimals)

        uint256 receiverBalBefore = networkConfig.token.balanceOf(receiver);

        vm.startPrank(address(networkConfig.endpoint));
        (bytes memory message, ) = OFTMsgCodec.encode(OFTComposeMsgCodec.addressToBytes32(address(receiver)), uint64(amount), "");
        IOAppReceiver(address(networkConfig.oft)).lzReceive(Origin(sendingSrcEid, OFTComposeMsgCodec.addressToBytes32(address(oftSender)), 0), 0, message, address(this), "");
    
        assertEq(networkConfig.token.balanceOf(receiver) - receiverBalBefore, amount * 1e12); // receiver received the tokens in local decimals

        vm.stopPrank();
    }

    function test_decimals_from_underlying_are_used() public {
        assertEq(networkConfig.token.decimals(), 18);

        // conversion rate is 1 because shared decimals is the same as the local decimals
        assertEq(networkConfig.oft.decimalConversionRate(), 10**12); 
    }

    function test_quote_oft() public {
        SendParam memory sendParam = SendParam({
            dstEid: sendingDstEid,
            to: bytes32(uint256(uint160(alice))),
            amountLD: 10_000e18,
            minAmountLD: 10_000e18,
            extraOptions: "",
            composeMsg: "",
            oftCmd: ""
        });

        (OFTLimit memory limit, OFTFeeDetail[] memory oftFeeDetails, OFTReceipt memory receipt) = networkConfig.oft.quoteOFT(sendParam);

        assertEq(limit.minAmountLD, 0);
        assertEq(limit.maxAmountLD, IERC20(networkConfig.token).totalSupply());

        assertEq(oftFeeDetails.length, 0);

        assertEq(receipt.amountSentLD, 10_000e18);
        assertEq(receipt.amountReceivedLD, 10_000e18);
    }

    function test_quote_send() public {
        SendParam memory sendParam = SendParam({
            dstEid: sendingDstEid,
            to: bytes32(uint256(uint160(alice))),
            amountLD: 10_000e18,
            minAmountLD: 10_000e18,
            extraOptions: "",
            composeMsg: "",
            oftCmd: ""
        });

        MessagingFee memory msgFee = networkConfig.oft.quoteSend(sendParam, false);

        if (block.chainid == ETH_CHAIN_ID) {
            assertLt(msgFee.nativeFee, 0.00008e18);
            assertGt(msgFee.nativeFee, 0.000005e18);
            assertEq(msgFee.lzTokenFee, 0);
        } else if (block.chainid == INK_CHAIN_ID) { 
            assertLt(msgFee.nativeFee, 0.008e18);
            assertGt(msgFee.nativeFee, 0.0001e18);
            assertEq(msgFee.lzTokenFee, 0);
        } else if (block.chainid == BERA_CHAIN_ID) {
            assertLt(msgFee.nativeFee, 5e18);
            assertGt(msgFee.nativeFee, 0.05e18);
            assertEq(msgFee.lzTokenFee, 0);
        } else if (block.chainid == ARB_CHAIN_ID) {
            assertLt(msgFee.nativeFee, 0.005e18); 
            assertGt(msgFee.nativeFee, 0.0001e18);
            assertEq(msgFee.lzTokenFee, 0);
        } else if (block.chainid == FLARE_CHAIN_ID) {
            assertLt(msgFee.nativeFee, 100e18); 
            assertGt(msgFee.nativeFee, 5e18);
            assertEq(msgFee.lzTokenFee, 0);
        } else if (block.chainid == CORN_CHAIN_ID) {
            assertLt(msgFee.nativeFee, 0.00005e18); 
            assertGt(msgFee.nativeFee, 0.0000001e18);
            assertEq(msgFee.lzTokenFee, 0);
        } else {
            revert("unsupported chain!");
        }
    }

    function test_oft_owner() public {
        assertEq(Ownable(address(networkConfig.oft)).owner(), networkConfig.safe);
    }

    function test_oft_delegate() public {
        assertEq(ILayerZeroEndpointDelegateable(address(networkConfig.endpoint)).delegates(address(networkConfig.oft)), networkConfig.safe);
    }

    function test_no_msg_inspector() public {
        assertEq(networkConfig.oft.msgInspector(), address(0));
    }

    function test_oft_token() public {
        assertEq(networkConfig.oft.token(), address(networkConfig.token));
    }

    function test_token_owner() public {
        assertEq(Ownable(address(networkConfig.token)).owner(), networkConfig.safe);
    }

    function test_lzReceive_gas() public {
        uint256 aliceBalBefore = networkConfig.token.balanceOf(alice);

        vm.startPrank(address(networkConfig.endpoint));
        (bytes memory message, ) = OFTMsgCodec.encode(OFTComposeMsgCodec.addressToBytes32(address(alice)), uint64(10_000), "");
        
        uint256 gasBefore = gasleft();
        IOAppReceiver(address(networkConfig.oft)).lzReceive(Origin(sendingSrcEid, OFTComposeMsgCodec.addressToBytes32(address(oftSender)), 0), 0, message, address(this), "");
        uint256 gasUsed = gasBefore - gasleft(); // inexact measurement for gut check

        vm.stopPrank();

        if (block.chainid == ETH_CHAIN_ID) {
            assertGt(gasUsed, 55_000);
            assertLt(gasUsed, 65_000);
        } else if (block.chainid == INK_CHAIN_ID) {
            assertGt(gasUsed, 55_000);
            assertLt(gasUsed, 65_000);
        } else if (block.chainid == BERA_CHAIN_ID) {
            assertGt(gasUsed, 50_000);
            assertLt(gasUsed, 65_000);
        } else {
            revert("unsupported chain!");
        }

        assertEq(networkConfig.token.balanceOf(alice) - aliceBalBefore, 10_000 * 1e12); // alice received the tokens
    }

    function test_lzReceive_gas_composed() public {
        uint256 aliceBalBefore = networkConfig.token.balanceOf(alice);

        vm.startPrank(address(networkConfig.endpoint));
        (bytes memory message, ) = OFTMsgCodec.encode(OFTComposeMsgCodec.addressToBytes32(address(alice)), uint64(10_000), encodeDummyData(100));
        
        uint256 gasBefore = gasleft();
        IOAppReceiver(address(networkConfig.oft)).lzReceive(Origin(sendingSrcEid, OFTComposeMsgCodec.addressToBytes32(address(oftSender)), 0), 0, message, address(this), "");
        uint256 gasUsed = gasBefore - gasleft(); // inexact measurement for gut check

        vm.stopPrank();

        if (block.chainid == ETH_CHAIN_ID) {
            assertGt(gasUsed, 85_000);
            assertLt(gasUsed, 95_000);
        } else if (block.chainid == INK_CHAIN_ID) {
            assertGt(gasUsed, 85_000);
            assertLt(gasUsed, 95_000);
        } else {
            revert("unsupported chain!");
        }

        assertEq(networkConfig.token.balanceOf(alice) - aliceBalBefore, 10_000 * 1e12); // alice received the tokens
    }

    function encodeDummyData(uint256 size) public pure returns (bytes memory) {
        bytes memory dummyData = new bytes(size);
        for (uint256 i = 0; i < size; i++) {
            dummyData[i] = bytes1(uint8(1 + i % 255));
        }
        return dummyData;
    }

    function test_verify_uln_config() public {

        console.log("#1 - Connection to ETH");
        if (block.chainid != ETH_CHAIN_ID) {
            
            address[] memory optionalDvns = new address[](0);
            console.log("#1.1");
            _verify_uln_config(
                ETH_EID,
                address(networkConfig.oft),
                networkConfig.sendLib,
                networkConfig.confirmations, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );
            console.log("#1.2");

            _verify_uln_config(
                ETH_EID,
                address(networkConfig.oft),
                networkConfig.receiveLib,
                FROM_ETH_CONFIRMATIONS, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );
        }

        console.log("#2 - Connection to Base");
        if (block.chainid != BASE_CHAIN_ID) {
            address[] memory optionalDvns = new address[](0);

            _verify_uln_config(
                BASE_EID,
                address(networkConfig.oft),
                networkConfig.sendLib,
                networkConfig.confirmations, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );

            _verify_uln_config(
                BASE_EID,
                address(networkConfig.oft),
                networkConfig.receiveLib,
                FROM_BASE_CONFIRMATIONS, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );
        }

        console.log("#3 - Connection to BSC");
        if (block.chainid != BSC_CHAIN_ID) {
            address[] memory optionalDvns = new address[](0);

            _verify_uln_config(
                BSC_EID,
                address(networkConfig.oft),
                networkConfig.sendLib,
                networkConfig.confirmations, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );

            _verify_uln_config(
                BSC_EID,
                address(networkConfig.oft),
                networkConfig.receiveLib,
                FROM_BSC_CONFIRMATIONS, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );
        }



        console.log("#4 - Connection to Bera");
        if (block.chainid != BERA_CHAIN_ID) {
            address[] memory optionalDvns = new address[](0);

            _verify_uln_config(
                BERA_EID,
                address(networkConfig.oft),
                networkConfig.sendLib,
                networkConfig.confirmations, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );

            _verify_uln_config(
                BERA_EID,
                address(networkConfig.oft),
                networkConfig.receiveLib,
                FROM_BERA_CONFIRMATIONS, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );
        }


        console.log("#5 - Connection to Botanix");
        if (block.chainid != BOTANIX_CHAIN_ID) {
            address[] memory optionalDvns = new address[](0);

            _verify_uln_config(
                BOTANIX_EID,
                address(networkConfig.oft),
                networkConfig.sendLib,
                networkConfig.confirmations, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );

            _verify_uln_config(
                BOTANIX_EID,
                address(networkConfig.oft),
                networkConfig.receiveLib,
                FROM_BOTANIX_CONFIRMATIONS, // confirmations
                networkConfig.dvns,
                optionalDvns,
                0
            );
        }

    }

    function _is_superchain(uint256 chainId) internal returns (bool) {
        return chainId == INK_CHAIN_ID || chainId == OPT_CHAIN_ID || chainId == UNI_CHAIN_ID;
    }

    function _verify_uln_config(
        uint32 _eid,
        address _oapp,
        address _lib,
        uint64 _confirmations,
        address[] memory _required_dvns,
        address[] memory _optional_dvns,
        uint8 _optionalDvnCount
    ) internal {
        bytes memory config = networkConfig.endpoint.getConfig(address(_oapp), _lib, _eid, 2);

        UlnConfig memory ulnConfig = abi.decode(config, (UlnConfig));
        // console.log("ulnConfig.confirmations:", ulnConfig.confirmations);
        // console.log("_lib:", _lib);

        assertEq(ulnConfig.confirmations, _confirmations);

        assertEq(ulnConfig.requiredDVNCount, _required_dvns.length);

        assertEq(ulnConfig.requiredDVNs.length, _required_dvns.length);

        assertEq(ulnConfig.optionalDVNCount, _optional_dvns.length);

        assertEq(ulnConfig.optionalDVNs.length, _optional_dvns.length);

        assertEq(ulnConfig.optionalDVNThreshold, _optionalDvnCount);

        for (uint i; i < _required_dvns.length; ++i) {
            assertEq(ulnConfig.requiredDVNs[i], _required_dvns[i]);
        }

        for (uint i; i < _optional_dvns.length; ++i) {
            assertEq(ulnConfig.optionalDVNs[i], _optional_dvns[i]);
        }

    }

}
