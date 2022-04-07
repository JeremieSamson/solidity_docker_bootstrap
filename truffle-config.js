module.exports = {
    networks: {
        development: {
            host: '127.0.0.1',
            port: 8545,
            network_id: '*'
        },
        docker: {
            host: 'ganache',
            port: 8545,
            network_id: '*',
            verbose: false
        }
    },
    mocha: {
        reporter: 'eth-gas-reporter'
    },
    compilers: {
        solc: {
            version: '0.8.13',
            docker: false,
            settings: {
                optimizer: {
                    enabled: false,
                    runs: 200
                },
                evmVersion: 'byzantium'
            }
        }
    },
    plugins: ['solidity-coverage']
}
