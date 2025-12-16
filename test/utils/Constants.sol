// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;


abstract contract EthereumConstants {
    uint256 constant ETH_CHAIN_ID = 1;
    address constant ENDPOINT_ETH = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant EXECUTOR_ETH = 0x173272739Bd7Aa6e4e214714048a9fE699453059;
    uint32 constant ETH_EID = 30101;
    address constant LZ_DVN_ETH = 0x589dEDbD617e0CBcB916A9223F4d1300c294236b;
    address constant SEND_LIB_ETH = 0xbB2Ea70C9E858123480642Cf96acbcCE1372dCe1; // SendUln302
    address constant RECEIVE_LIB_ETH = 0xc02Ab410f0734EFa3F14628780e6e695156024C2; // ReceiveUln302
    uint64 constant FROM_ETH_CONFIRMATIONS = 15;
    address constant SAFE_ETH = 0x8D1d2e24eC641eDC6a1ebe0F3aE7af0EBC573e0D;
    address constant CANARY_DVN_ETH = 0xa4fE5A5B9A846458a70Cd0748228aED3bF65c2cd;
}

abstract contract BaseConstants {
    uint256 constant BASE_CHAIN_ID = 8453;
    address constant ENDPOINT_BASE = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant EXECUTOR_BASE = 0x2CCA08ae69E0C44b18a57Ab2A87644234dAebaE4;
    uint32 constant BASE_EID = 30184;
    address constant LZ_DVN_BASE = 0x6498b0632f3834D7647367334838111c8C889703;
    address constant SEND_LIB_BASE = 0xB5320B0B3a13cC860893E2Bd79FCd7e13484Dda2; // SendUln302
    address constant RECEIVE_LIB_BASE = 0xc70AB6f32772f59fBfc23889Caf4Ba3376C84bAf; // ReceiveUln302
    uint64 constant FROM_BASE_CONFIRMATIONS = 15;
    address constant SAFE_BASE = address(0);
}


abstract contract ArbitrumConstants {    
    uint256 constant ARB_CHAIN_ID = 42161;
    address constant ENDPOINT_ARB = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_ARB = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_ARB = 0x31CAe3B7fB82d847621859fb1585353c5720660D;
    uint32 constant ARB_EID = 30110;
    address constant LZ_DVN_ARB = 0x2f55C492897526677C5B68fb199ea31E2c126416;
    address constant SEND_LIB_ARB = 0x975bcD720be66659e3EB3C0e4F1866a3020E493A; // SendUln302
    address constant RECEIVE_LIB_ARB = 0x7B9E184e07a6EE1aC23eAe0fe8D6Be2f663f05e6; // ReceiveUln302
    uint64 constant FROM_ARB_CONFIRMATIONS = 60;
}

abstract contract InkConstants {
    uint256 constant INK_CHAIN_ID = 57073;
    address constant ENDPOINT_INK = 0xca29f3A6f966Cb2fc0dE625F8f325c0C46dbE958;
    address constant SAFE_INK = 0xc95de55ce5e93f788A1Faab2A9c9503F51a5dAE2;
    address constant EXECUTOR_INK = 0xFEbCF17b11376C724AB5a5229803C6e838b6eAe5;
    uint32 constant INK_EID = 30339;
    address constant LZ_DVN_INK = 0x174F2bA26f8ADeAfA82663bcf908288d5DbCa649;
    address constant SEND_LIB_INK = 0x76111DE813F83AAAdBD62773Bf41247634e2319a; // SendUln302
    address constant RECEIVE_LIB_INK = 0x473132bb594caEF281c68718F4541f73FE14Dc89; // ReceiveUln302
    uint64 constant FROM_INK_CONFIRMATIONS = 450;
}


abstract contract BerachainConstants {
    uint256 constant BERA_CHAIN_ID = 80094;
    address constant ENDPOINT_BERA = 0x6F475642a6e85809B1c36Fa62763669b1b48DD5B;
    address constant SAFE_BERA = 0x425d1D17C33bdc0615eA18D1b18CCA7e14bEeb58;
    uint32 constant BERA_EID = 30362;
    address constant EXECUTOR_BERA = 0x4208D6E27538189bB48E603D6123A94b8Abe0A0b;
    address constant LZ_DVN_BERA = 0x282b3386571f7f794450d5789911a9804FA346b4;
    address constant SEND_LIB_BERA = 0xC39161c743D0307EB9BCc9FEF03eeb9Dc4802de7; // SendUln302
    address constant RECEIVE_LIB_BERA = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // ReceiveUln302
    uint64 constant FROM_BERA_CONFIRMATIONS = 60;
}


abstract contract FlareConstants {
    uint256 constant FLARE_CHAIN_ID = 14;
    address constant ENDPOINT_FLARE = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_FLARE = 0x6ae078461f35c3cC216A71029F71ee7Bc4d9a10b;
    uint32 constant FLARE_EID = 30295;
    address constant EXECUTOR_FLARE = 0xcCE466a522984415bC91338c232d98869193D46e;
    address constant LZ_DVN_FLARE = 0x9C061c9A4782294eeF65ef28Cb88233A987F4bdD;
    address constant SEND_LIB_FLARE = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // SendUln302
    address constant RECEIVE_LIB_FLARE = 0x2367325334447C5E1E0f1b3a6fB947b262F58312; // ReceiveUln302
    uint64 constant FROM_FLARE_CONFIRMATIONS = 500;
}


abstract contract CornConstants {
    uint256 constant CORN_CHAIN_ID = 21000000;
    address constant ENDPOINT_CORN = 0xcb566e3B6934Fa77258d68ea18E931fa75e1aaAa;
    address constant SAFE_CORN = 0x57d798f9d3B014bAC81A6B9fb3c18c0242A9411E;
    uint32 constant CORN_EID = 30331;
    address constant EXECUTOR_CORN = 0xa20DB4Ffe74A31D17fc24BD32a7DD7555441058e;
    address constant LZ_DVN_CORN = 0x6788f52439ACA6BFF597d3eeC2DC9a44B8FEE842;
    address constant SEND_LIB_CORN = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // SendUln302
    address constant RECEIVE_LIB_CORN = 0x2367325334447C5E1E0f1b3a6fB947b262F58312; // ReceiveUln302
    uint64 constant FROM_CORN_CONFIRMATIONS = 2800;
    address constant MULTI_SEND_CONTRACT_CORN = 0x40A2aCCbd92BCA938b02010E17A5b8929b49130D;
}

abstract contract OptimismConstants {
    uint256 constant OPT_CHAIN_ID = 10;
    address constant ENDPOINT_OPT = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_OPT = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_OPT = 0x2D2ea0697bdbede3F01553D2Ae4B8d0c486B666e;
    uint32 constant OPT_EID = 30111;
    address constant LZ_DVN_OPT = 0x6A02D83e8d433304bba74EF1c427913958187142; 
    address constant SEND_LIB_OPT = 0x1322871e4ab09Bc7f5717189434f97bBD9546e95; // SendUln302
    address constant RECEIVE_LIB_OPT = 0x3c4962Ff6258dcfCafD23a814237B7d6Eb712063; // ReceiveUln302
    uint64 constant FROM_OPT_CONFIRMATIONS = 450;
}

abstract contract UnichainConstants {
    uint256 constant UNI_CHAIN_ID = 130;
    address constant ENDPOINT_UNI = 0x6F475642a6e85809B1c36Fa62763669b1b48DD5B;
    address constant SAFE_UNI = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_UNI = 0x4208D6E27538189bB48E603D6123A94b8Abe0A0b;
    uint32 constant UNI_EID = 30320;
    address constant LZ_DVN_UNI = 0x282b3386571f7f794450d5789911a9804FA346b4;
    address constant SEND_LIB_UNI = 0xC39161c743D0307EB9BCc9FEF03eeb9Dc4802de7; // SendUln302
    address constant RECEIVE_LIB_UNI = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // ReceiveUln302
    uint64 constant FROM_UNI_CONFIRMATIONS = 450;
}

abstract contract SeiConstants {
    uint256 constant SEI_CHAIN_ID = 1329;
    address constant ENDPOINT_SEI = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_SEI = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_SEI = 0xc097ab8CD7b053326DFe9fB3E3a31a0CCe3B526f;
    uint32 constant SEI_EID = 30280;
    address constant LZ_DVN_SEI = 0x6788f52439ACA6BFF597d3eeC2DC9a44B8FEE842;
    address constant SEND_LIB_SEI = 0xC39161c743D0307EB9BCc9FEF03eeb9Dc4802de7; // SendUln302
    address constant RECEIVE_LIB_SEI = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // ReceiveUln302
    uint64 constant FROM_SEI_CONFIRMATIONS = 2000;
}

abstract contract HyperConstants {
    uint256 constant HYPER_CHAIN_ID = 999;
    address constant ENDPOINT_HYPER = 0x3A73033C0b1407574C76BdBAc67f126f6b4a9AA9;
    address constant SAFE_HYPER = 0xB64A89AD247a2D691A728Bb6822a85EeDD7Fc541;
    address constant EXECUTOR_HYPER = 0x41Bdb4aa4A63a5b2Efc531858d3118392B1A1C3d;
    uint32 constant HYPER_EID = 30367;
    address constant LZ_DVN_HYPER = 0xc097ab8CD7b053326DFe9fB3E3a31a0CCe3B526f;
    address constant SEND_LIB_HYPER = 0xfd76d9CB0Bac839725aB79127E7411fe71b1e3CA; // SendUln302
    address constant RECEIVE_LIB_HYPER = 0x7cacBe439EaD55fa1c22790330b12835c6884a91; // ReceiveUln302
    uint64 constant FROM_HYPER_CONFIRMATIONS = 43200;
}

abstract contract RootConstants {
    uint256 constant ROOT_CHAIN_ID = 30;
    address constant ENDPOINT_ROOT = 0xcb566e3B6934Fa77258d68ea18E931fa75e1aaAa;
    address constant SAFE_ROOT = 0x425d1D17C33bdc0615eA18D1b18CCA7e14bEeb58;
    address constant EXECUTOR_ROOT= 0xa20DB4Ffe74A31D17fc24BD32a7DD7555441058e;
    uint32 constant ROOT_EID = 30333;
    address constant LZ_DVN_ROOT = 0x6788f52439ACA6BFF597d3eeC2DC9a44B8FEE842;
    address constant SEND_LIB_ROOT = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // SendUln302
    address constant RECEIVE_LIB_ROOT = 0x2367325334447C5E1E0f1b3a6fB947b262F58312; // ReceiveUln302
    uint64 constant FROM_ROOT_CONFIRMATIONS = 500;
}

abstract contract PlasmaConstants {
    uint256 constant PLASMA_CHAIN_ID = 9745;
    address constant ENDPOINT_PLASMA = 0x6F475642a6e85809B1c36Fa62763669b1b48DD5B;
    address constant SAFE_PLASMA = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_PLASMA= 0x4208D6E27538189bB48E603D6123A94b8Abe0A0b;
    uint32 constant PLASMA_EID = 30383;
    address constant LZ_DVN_PLASMA = 0x282b3386571f7f794450d5789911a9804FA346b4;
    address constant SEND_LIB_PLASMA = 0xC39161c743D0307EB9BCc9FEF03eeb9Dc4802de7; // SendUln302
    address constant RECEIVE_LIB_PLASMA = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // ReceiveUln302
    uint64 constant FROM_PLASMA_CONFIRMATIONS = 3600;
}

abstract contract AvaxConstants {
    uint256 constant AVAX_CHAIN_ID = 43114;
    address constant ENDPOINT_AVAX = 0x1a44076050125825900e736c501f859c50fE728c;
    uint32  constant AVAX_EID      = 30106;
    address constant LZ_DVN_AVAX = 0x962F502A63F5FBeB44DC9ab932122648E8352959;
    address constant SEND_LIB_AVAX = 0x197D1333DEA5Fe0D6600E9b396c7f1B1cFCc558a; // SendUln302
    address constant RECEIVE_LIB_AVAX = 0xbf3521d309642FA9B1c91A08609505BA09752c61; // ReceiveUln302

    address constant SAFE_AVAX = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_AVAX = 0x90E595783E43eb89fF07f63d27B8430e6B44bD9c;
    uint64 constant FROM_AVAX_CONFIRMATIONS = 60;
}

abstract contract PolygonConstants {
    uint256 constant POL_CHAIN_ID = 137;
    address constant ENDPOINT_POL     = 0x1a44076050125825900e736c501f859c50fE728c;
    uint32  constant POL_EID         = 30109;
    address constant SEND_LIB_POL = 0x6c26c61a97006888ea9E4FA36584c7df57Cd9dA3; // SendUln302
    address constant RECEIVE_LIB_POL = 0x1322871e4ab09Bc7f5717189434f97bBD9546e95; // ReceiveUln302
    address constant LZ_DVN_POL = 0x23DE2FE932d9043291f870324B74F820e11dc81A;
    address constant EXECUTOR_POLYGON = 0xe25741bda30bb79a66ADf656E7f2D3f0C4fb3191;
    address constant SAFE_POLYGON = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;

    uint64 constant FROM_POL_CONFIRMATIONS = 32;
}

abstract contract CeloConstants {
    uint256 constant CELO_CHAIN_ID = 42220;
    address constant ENDPOINT_CELO = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_CELO = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_CELO = 0x1dDbaF8b75F2291A97C22428afEf411b7bB19e28;
    uint32 constant CELO_EID = 30125;
    address constant LZ_DVN_CELO = 0x75b073994560A5c03Cd970414d9170be0C6e5c36;
    address constant SEND_LIB_CELO = 0x42b4E9C6495B4cFDaE024B1eC32E09F28027620e; // SendUln302
    address constant RECEIVE_LIB_CELO = 0xaDDed4478B423d991C21E525Cd3638FBce1AaD17; // ReceiveUln302
    uint64 constant FROM_CELO_CONFIRMATIONS = 450;
}

abstract contract XLayerConstants {
    uint256 constant XLAYER_CHAIN_ID = 196;
    address constant ENDPOINT_XLAYER = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_XLAYER = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_XLAYER = 0xcCE466a522984415bC91338c232d98869193D46e;
    uint32 constant XLAYER_EID = 30274;
    address constant OFT_XLAYER = 0x94BCCa6bdfd6A61817Ab0E960bFedE4984505554;
    address constant LZ_DVN_XLAYER = 0x9C061c9A4782294eeF65ef28Cb88233A987F4bdD;
    address constant SEND_LIB_XLAYER = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // SendUln302
    address constant RECEIVE_LIB_XLAYER = 0x2367325334447C5E1E0f1b3a6fB947b262F58312; // ReceiveUln302
    uint64 constant FROM_XLAYER_CONFIRMATIONS = 9000;
}

abstract contract ConfluxConstants {
    uint256 constant CONFLUX_CHAIN_ID = 1030;
    address constant ENDPOINT_CONFLUX = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_CONFLUX = 0x789498616f3Bb9F8dF52288A9311247028872105;
    address constant EXECUTOR_CONFLUX = 0x07Dd1bf9F684D81f59B6a6760438d383ad755355;
    uint32 constant CONFLUX_EID = 30212;
    address constant LZ_DVN_CONFLUX = 0x8D183A062e99cad6f3723E6d836F9EA13886B173;
    address constant SEND_LIB_CONFLUX = 0xb360A579Dc6f77d6a3E8710A9d983811129C428d; // SendUln302
    address constant RECEIVE_LIB_CONFLUX = 0x16Cc4EF7c128d7FEa96Cf46FFD9dD20f76170347; // ReceiveUln302
    uint64 constant FROM_CONFLUX_CONFIRMATIONS = 2800;
}

abstract contract MonadConstants {
    uint256 constant MONAD_CHAIN_ID = 143;
    address constant ENDPOINT_MONAD = 0x6F475642a6e85809B1c36Fa62763669b1b48DD5B;
    address constant SAFE_MONAD = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_MONAD = 0x4208D6E27538189bB48E603D6123A94b8Abe0A0b;
    uint32 constant MONAD_EID = 30390;
    address constant LZ_DVN_MONAD = 0x282b3386571f7f794450d5789911a9804FA346b4;
    address constant SEND_LIB_MONAD = 0xC39161c743D0307EB9BCc9FEF03eeb9Dc4802de7; // SendUln302
    address constant RECEIVE_LIB_MONAD = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // ReceiveUln302
    uint64 constant FROM_MONAD_CONFIRMATIONS = 3600;
}

abstract contract MantleConstants {
    uint256 constant MANTLE_CHAIN_ID = 5000;
    address constant ENDPOINT_MANTLE = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_MANTLE = 0x4DFF9b5b0143E642a3F63a5bcf2d1C328e600bf8;
    address constant EXECUTOR_MANTLE = 0x4Fc3f4A38Acd6E4cC0ccBc04B3Dd1CCAeFd7F3Cd;
    uint32 constant MANTLE_EID = 30181;
    address constant LZ_DVN_MANTLE = 0x28B6140ead70cb2Fb669705b3598ffB4BEaA060b; // LayerZero Labs DVN
    address constant SEND_LIB_MANTLE = 0xde19274c009A22921E3966a1Ec868cEba40A5DaC; // SendUln302
    address constant RECEIVE_LIB_MANTLE = 0x8da6512De9379fBF4F09BF520Caf7a85435ed93e; // ReceiveUln302
    uint64 constant FROM_MANTLE_CONFIRMATIONS = 2000;
}

abstract contract BscConstants {
    uint256 constant BSC_CHAIN_ID = 56;
    address constant ENDPOINT_BSC = 0x1a44076050125825900e736c501f859c50fE728c;
    address constant SAFE_BSC = address(0);
    address constant EXECUTOR_BSC = 0x3ebD570ed38B1b3b4BC886999fcF507e9D584859;
    uint32 constant BSC_EID = 30102;
    address constant LZ_DVN_BSC = 0xe9b5E4f9395a60799F4F608Ba3ABebDfC0ee6D9C;
    address constant SEND_LIB_BSC = 0x9F8C645f2D0b2159767Bd6E0839DE4BE49e823DE; // SendUln302
    address constant RECEIVE_LIB_BSC = 0xB217266c3A98C8B2709Ee26836C98cf12f6cCEC1; // ReceiveUln302
    uint64 constant FROM_BSC_CONFIRMATIONS = 15;
}

abstract contract BotanixConstants {
    uint256 constant BOTANIX_CHAIN_ID = 3637;
    address constant ENDPOINT_BOTANIX = 0x6F475642a6e85809B1c36Fa62763669b1b48DD5B;
    address constant SAFE_BOTANIX = address(0);
    address constant EXECUTOR_BOTANIX = 0x4208D6E27538189bB48E603D6123A94b8Abe0A0b;
    uint32 constant BOTANIX_EID = 30376;
    address constant LZ_DVN_BOTANIX = 0x6788f52439ACA6BFF597d3eeC2DC9a44B8FEE842;
    address constant SEND_LIB_BOTANIX = 0xC39161c743D0307EB9BCc9FEF03eeb9Dc4802de7; // SendUln302
    address constant RECEIVE_LIB_BOTANIX = 0xe1844c5D63a9543023008D332Bd3d2e6f1FE1043; // ReceiveUln302
    uint64 constant FROM_BOTANIX_CONFIRMATIONS = 60;
}


abstract contract Constants is EthereumConstants, BaseConstants, ArbitrumConstants, InkConstants, BerachainConstants, FlareConstants, CornConstants, UnichainConstants, OptimismConstants, SeiConstants, HyperConstants, RootConstants, PlasmaConstants, AvaxConstants, PolygonConstants, CeloConstants, XLayerConstants, ConfluxConstants, MonadConstants, MantleConstants, BscConstants, BotanixConstants {

    // This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1
    bytes32 constant PROXY_ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    uint16 constant MSG_TYPE_SEND = 1;
    uint16 constant MSG_TYPE_SEND_AND_CALL = 2;

    uint32 DEFAULT_MAX_MESSAGE_SIZE = 10_000;

    uint64 constant SUPERCHAIN_CONFIRMATIONS = 30;
}
