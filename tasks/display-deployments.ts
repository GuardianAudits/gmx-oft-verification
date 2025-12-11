import fs from 'fs'
import path from 'path'

import { task } from 'hardhat/config'
import { HardhatRuntimeEnvironment } from 'hardhat/types'

/**
 * Block explorer URLs for each network
 */
const BLOCK_EXPLORERS: Record<string, string> = {
    'arbitrum-mainnet': 'https://arbiscan.io/address',
    'base-mainnet': 'https://basescan.org/address',
    'bera-mainnet': 'https://berascan.com/address',
    'botanix-mainnet': 'https://botanixscan.io/address',
    'bsc-mainnet': 'https://bscscan.com/address',
    'ethereum-mainnet': 'https://etherscan.io/address',
    'arbitrum-testnet': 'https://sepolia.arbiscan.io/address',
    'ethereum-testnet': 'https://sepolia.etherscan.io/address',
}

/**
 * Creates a clickable terminal link (works in most modern terminals)
 */
function createClickableLink(text: string, url: string): string {
    // ANSI escape code for hyperlinks: \x1b]8;;URL\x1b\\TEXT\x1b]8;;\x1b\\
    return `\x1b]8;;${url}\x1b\\${text}\x1b]8;;\x1b\\`
}

/**
 * Formats an address with a clickable link to block explorer
 */
function formatAddressLink(address: string, network: string): string {
    const explorerBase = BLOCK_EXPLORERS[network]
    if (explorerBase) {
        const url = `${explorerBase}/${address}`
        return createClickableLink(address, url)
    }
    return address // No link if explorer not configured
}

interface DeploymentInfo {
    network: string
    address: string
    contractType: 'Adapter' | 'OFT'
}

interface GroupedDeployments {
    [marketPair: string]: {
        GM: DeploymentInfo[]
        GLV: DeploymentInfo[]
    }
}

const displayDeployments = task(
    'lz:sdk:display-deployments',
    'Display deployed contracts grouped by market pair and token type'
)
    .addOptionalParam('filterNetworks', 'Filter by specific network (e.g., arbitrum-mainnet)')
    .addFlag('mainnet', 'Show only mainnet deployments')
    .addFlag('testnet', 'Show only testnet deployments')
    .setAction(async (taskArgs, hre: HardhatRuntimeEnvironment) => {
        const deploymentsDir = path.join(process.cwd(), 'deployments')

        if (!fs.existsSync(deploymentsDir)) {
            console.error('❌ No deployments directory found')
            return
        }

        const networks = fs
            .readdirSync(deploymentsDir, { withFileTypes: true })
            .filter((dirent) => dirent.isDirectory())
            .map((dirent) => dirent.name)
            .filter((network) => {
                if (taskArgs.filterNetworks) return network === taskArgs.filterNetworks
                if (taskArgs.mainnet) return network.includes('mainnet') && !network.includes('testnet')
                if (taskArgs.testnet) return network.includes('testnet')
                return true
            })

        const grouped: GroupedDeployments = {}

        for (const network of networks) {
            const networkDir = path.join(deploymentsDir, network)
            const files = fs
                .readdirSync(networkDir)
                .filter((file) => file.endsWith('.json') && !file.includes('solcInputs'))

            for (const file of files) {
                const filePath = path.join(networkDir, file)

                try {
                    const deployment = JSON.parse(fs.readFileSync(filePath, 'utf8'))

                    // Parse filename: {TokenType}_{ContractType}_{MarketPair}.json
                    const match = file.match(/^(GlvToken|MarketToken)_(Adapter|OFT)_(.+)\.json$/)
                    if (!match) continue

                    const [, tokenType, contractType, marketPair] = match
                    const tokenCategory = tokenType === 'GlvToken' ? 'GLV' : 'GM'

                    if (!grouped[marketPair]) {
                        grouped[marketPair] = { GM: [], GLV: [] }
                    }

                    grouped[marketPair][tokenCategory].push({
                        network,
                        address: deployment.address,
                        contractType: contractType as 'Adapter' | 'OFT',
                    })
                } catch (error) {
                    console.warn(`⚠️  Failed to parse ${file}: ${error}`)
                }
            }
        }

        // Display results
        console.log('Deployed Contracts by Market Pair\n')

        const marketPairs = Object.keys(grouped).sort()

        if (marketPairs.length === 0) {
            console.error('No deployments found matching the criteria')
            return
        }

        for (let i = 0; i < marketPairs.length; i++) {
            const marketPair = marketPairs[i]
            const deployments = grouped[marketPair]

            console.log(`${i + 1}. ${marketPair.replace(/_/g, '-')}`)

            // GM Tokens
            console.log('   GM Tokens:')
            if (deployments.GM.length === 0) {
                console.log('     (none)')
            } else {
                deployments.GM.forEach((dep) => {
                    const addressLink = formatAddressLink(dep.address, dep.network)
                    console.log(`     ${dep.network}: ${addressLink} (${dep.contractType})`)
                })
            }

            // GLV Tokens
            console.log('   GLV Tokens:')
            if (deployments.GLV.length === 0) {
                console.log('     (none)')
            } else {
                deployments.GLV.forEach((dep) => {
                    const addressLink = formatAddressLink(dep.address, dep.network)
                    console.log(`     ${dep.network}: ${addressLink} (${dep.contractType})`)
                })
            }

            if (i < marketPairs.length - 1) console.log('')
        }

        // Summary
        const totalContracts = Object.values(grouped).reduce((sum, pair) => sum + pair.GM.length + pair.GLV.length, 0)
        console.log(`\nSummary: ${marketPairs.length} market pairs, ${totalContracts} contracts`)
    })

export { displayDeployments }
