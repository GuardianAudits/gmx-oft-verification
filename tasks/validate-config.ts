import * as CliTable3 from 'cli-table3'
import { Contract } from 'ethers'
import { task } from 'hardhat/config'
import { HardhatRuntimeEnvironment } from 'hardhat/types'

import { TokenConfig, Tokens, validateHubNetworksNotInExpansion } from '../devtools'

// ERC20 ABI for getting token info
const ERC20_ABI = [
    'function name() view returns (string)',
    'function symbol() view returns (string)',
    'function decimals() view returns (uint8)',
]

interface ValidationResult {
    marketPair: string
    tokenType: 'GM' | 'GLV'
    network: string
    contractAddress: string
    configSymbol: string
    onChainSymbol: string
    decimals: number
    symbolMatch: boolean
}

async function validateTokenConfig(
    hre: HardhatRuntimeEnvironment,
    marketPair: string,
    tokenType: 'GM' | 'GLV',
    tokenConfig: TokenConfig
): Promise<ValidationResult> {
    // Get network name from endpoint ID
    const networkName =
        Object.entries(hre.config.networks).find(
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            ([_, networkConfig]) => (networkConfig as any).eid === tokenConfig.hubNetwork.eid
        )?.[0] || 'unknown'

    // Connect to the appropriate network
    const provider = hre.ethers.provider
    if (networkName !== 'unknown' && networkName !== hre.network.name) {
        // Switch to the hub network if not already connected
        const hubNetwork = hre.config.networks[networkName]
        if (hubNetwork && 'url' in hubNetwork) {
            const newProvider = new hre.ethers.providers.JsonRpcProvider(hubNetwork.url)
            const contract = new Contract(tokenConfig.hubNetwork.contractAddress, ERC20_ABI, newProvider)

            const [onChainSymbol, decimals] = await Promise.all([contract.symbol(), contract.decimals()])

            return {
                marketPair,
                tokenType,
                network: networkName,
                contractAddress: tokenConfig.hubNetwork.contractAddress,
                configSymbol: tokenConfig.tokenSymbol,
                onChainSymbol,
                decimals,
                symbolMatch: tokenConfig.tokenSymbol === onChainSymbol,
            }
        }
    }

    // Fallback: use current provider (assuming we're on the correct network)
    const contract = new Contract(tokenConfig.hubNetwork.contractAddress, ERC20_ABI, provider)

    const [onChainSymbol, decimals] = await Promise.all([contract.symbol(), contract.decimals()])

    return {
        marketPair,
        tokenType,
        network: networkName,
        contractAddress: tokenConfig.hubNetwork.contractAddress,
        configSymbol: tokenConfig.tokenSymbol,
        onChainSymbol,
        decimals,
        symbolMatch: tokenConfig.tokenSymbol === onChainSymbol,
    }
}

function formatTable(results: ValidationResult[]): void {
    console.log('\nConfiguration Validation Results')

    const table = new CliTable3.default({
        head: ['Market Pair', 'Type', 'Contract Address', 'On-Chain Symbol', 'Match', 'Decimals'],
        colWidths: [16, 6, 44, 20, 7, 10],
        wordWrap: true,
        wrapOnWordBoundary: false,
    })

    results.forEach((result) => {
        table.push([
            result.marketPair,
            result.tokenType,
            result.contractAddress,
            result.onChainSymbol,
            result.symbolMatch ? '✅' : '❌',
            result.decimals.toString(),
        ])
    })

    console.log(table.toString())

    // Summary
    const gmResults = results.filter((r) => r.tokenType === 'GM')
    const glvResults = results.filter((r) => r.tokenType === 'GLV')
    const mismatches = results.filter((r) => !r.symbolMatch)
    const gmMismatches = mismatches.filter((r) => r.tokenType === 'GM')
    const glvMismatches = mismatches.filter((r) => r.tokenType === 'GLV')

    console.log('\nSummary:')
    console.log(`   Total tokens validated: ${results.length}`)
    if (gmResults.length > 0) console.log(`     GM tokens: ${gmResults.length}`)
    if (glvResults.length > 0) console.log(`     GLV tokens: ${glvResults.length}`)
    console.log(`   Total mismatches: ${mismatches.length}`)

    if (mismatches.length > 0) {
        console.log('\n⚠️  Token Mismatches (these need attention):')
        if (gmMismatches.length > 0) {
            console.log('   GM Tokens (should be "GM"):')
            gmMismatches.forEach((result) => {
                console.log(`     ${result.marketPair}: on-chain symbol is "${result.onChainSymbol}" (expected "GM")`)
            })
        }
        if (glvMismatches.length > 0) {
            console.log('   GLV Tokens (should match config):')
            glvMismatches.forEach((result) => {
                console.log(`     ${result.marketPair}: "${result.configSymbol}" ≠ "${result.onChainSymbol}"`)
            })
        }
    } else {
        console.log('   ✅ All tokens match their expected on-chain values!')
    }
}

interface ValidateConfigArgs {
    marketPair?: string
    tokenType?: 'GM' | 'GLV'
}

task('lz:sdk:validate-config', 'Validates the devtools configuration against on-chain token data')
    .addOptionalParam('marketPair', 'Filter by specific market pair (e.g., WETH_USDC)')
    .addOptionalParam('tokenType', 'Filter by token type (GM or GLV)')
    .setAction(async (taskArgs: ValidateConfigArgs, hre: HardhatRuntimeEnvironment) => {
        const { marketPair: filterMarketPair, tokenType: filterTokenType } = taskArgs

        // Validate token type if provided
        if (filterTokenType && !['GM', 'GLV'].includes(filterTokenType)) {
            throw new Error(`Invalid token type: ${filterTokenType}. Must be GM or GLV`)
        }
        console.log('Starting configuration validation...\n')

        // First, validate that hub networks are not in expansion networks
        console.log('🔍 Validating configuration structure...')
        const tokensToValidate = filterMarketPair
            ? { [filterMarketPair]: Tokens[filterMarketPair] }
            : Tokens

        if (filterMarketPair && !tokensToValidate[filterMarketPair]) {
            throw new Error(`Market pair '${filterMarketPair}' not found. Available: ${Object.keys(Tokens).join(', ')}`)
        }

        for (const [marketPairKey, marketPairConfig] of Object.entries(tokensToValidate)) {
            try {
                validateHubNetworksNotInExpansion(marketPairConfig)
                console.log(`✅ ${marketPairKey}: Configuration structure valid`)
            } catch (error) {
                console.error(`❌ ${marketPairKey}: ${error instanceof Error ? error.message : String(error)}`)
                return
            }
        }

        console.log('\n🔍 Validating on-chain token data...')
        console.log('ℹ️  GM tokens: Checking that on-chain name is "GM" (hub uses generic name)')
        console.log('ℹ️  GLV tokens: Checking that on-chain name matches config name\n')
        
        const results: ValidationResult[] = []

        // Process each market pair in the config
        for (const [marketPairKey, marketPairConfig] of Object.entries(tokensToValidate)) {
            // Validate GM token if configured and not filtered out
            if (marketPairConfig.GM && (!filterTokenType || filterTokenType === 'GM')) {
                console.log(`📈 Processing ${marketPairKey} GM...`)
                try {
                    const gmResult = await validateTokenConfig(hre, marketPairKey, 'GM', marketPairConfig.GM)
                    // For GM tokens, we expect on-chain name to be "GM"
                    gmResult.symbolMatch = gmResult.onChainSymbol === 'GM'
                    results.push(gmResult)
                } catch (error) {
                    console.error(`   ❌ Error validating ${marketPairKey} GM:`, error)
                }
            }

            // Validate GLV token if configured and not filtered out
            if (marketPairConfig.GLV && (!filterTokenType || filterTokenType === 'GLV')) {
                console.log(`📈 Processing ${marketPairKey} GLV...`)
                try {
                    const glvResult = await validateTokenConfig(hre, marketPairKey, 'GLV', marketPairConfig.GLV)
                    results.push(glvResult)
                } catch (error) {
                    console.error(`   ❌ Error validating ${marketPairKey} GLV:`, error)
                }
            }

            // Log if neither is configured or both filtered out
            const hasGM = marketPairConfig.GM && (!filterTokenType || filterTokenType === 'GM')
            const hasGLV = marketPairConfig.GLV && (!filterTokenType || filterTokenType === 'GLV')
            if (!hasGM && !hasGLV) {
                if (filterTokenType) {
                    console.log(`⏭️  Skipping ${marketPairKey} - no ${filterTokenType} token configured`)
                } else {
                    console.log(`⏭️  Skipping ${marketPairKey} - no tokens configured`)
                }
            }
        }

        // Display results in a formatted table
        formatTable(results)
    }
)

export { validateTokenConfig, formatTable }
