# HarmonyChain

HarmonyChain is a decentralized music collaboration platform built on the Stacks blockchain using Clarity smart contracts. It allows musicians to tokenize their compositions, collaborate with others, and manage royalties through smart contracts.

## Features

- Create and tokenize musical compositions as NFTs
- Invite collaborators to participate in compositions
- Set and manage royalty percentages for compositions
- Accept collaboration invitations
- Retrieve composition and collaboration details

## Prerequisites

Before you begin, ensure you have met the following requirements:

- [Clarinet](https://github.com/hirosystems/clarinet) installed (version 0.14.0 or later)
- [Node.js](https://nodejs.org/) installed (version 14 or later)
- Basic knowledge of Clarity smart contracts and Stacks blockchain

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/harmony-chain.git
   cd harmony-chain
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Run tests:
   ```
   clarinet test
   ```

## Usage

Here are some examples of how to interact with the HarmonyChain smart contract:

1. Create a new composition:
   ```clarity
   (contract-call? .harmony-chain create-composition "My Awesome Song" "QmHash123" u10)
   ```

2. Invite a collaborator:
   ```clarity
   (contract-call? .harmony-chain invite-collaborator u0 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM u5)
   ```

3. Accept a collaboration invitation:
   ```clarity
   (contract-call? .harmony-chain accept-collaboration u0)
   ```

4. Get composition details:
   ```clarity
   (contract-call? .harmony-chain get-composition u0)
   ```

5. Get collaboration details:
   ```clarity
   (contract-call? .harmony-chain get-collaboration u0 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
   ```

## Smart Contract Functions

- `create-composition`: Create a new composition NFT
- `invite-collaborator`: Invite a collaborator to a composition
- `accept-collaboration`: Accept a collaboration invitation
- `get-composition`: Retrieve composition details
- `get-collaboration`: Retrieve collaboration details

## Contributing

Contributions to HarmonyChain are welcome! Here are some ways you can contribute:

1. Report bugs
2. Suggest new features
3. Write or improve documentation
4. Submit pull requests with code improvements

Please make sure to update tests as appropriate.

## License

[MIT License](LICENSE)

## Contact

If you have any questions or feedback, please open an issue on the GitHub repository.

Happy collaborating with HarmonyChain!