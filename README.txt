# Real Estate Auction Project using ERC-6551

## Introduction

The Real Estate Auction Project is a decentralized application (DAO) that facilitates the sale of properties using the ERC-6551 standard for token-bound accounts. This project involves four main parties: the Proposer (property owner), the ProposerAdminContract (smart contract where the NFT is temporarily locked before being launched for sale), the Custodian, and the Verifier. The Custodian and Verifier are responsible for verifying the property and providing their input before the NFT can be unlocked and put up for sale.

## Project Flow

1. `Creation of NFT`: The Proposer initiates the process by creating an NFT that contains all the details of the property they wish to sell. This NFT acts as a representation of the property and will be used in the auction process.

2. `Transfer of NFT to ProposerAdminContract`: After creating the NFT, the Proposer transfers the NFT to the ProposerAdminContract. This smart contract will temporarily lock the NFT until the auction process is complete.

3. `Locking the NFT`: The NFT is locked in the ProposerAdminContract, preventing it from being used or transferred during the verification process.

4. `Consent from Custodian and Verifier`: To unlock the NFT, both the Custodian and Verifier must provide their consent for the property. This consent process occurs off-chain and involves a thorough examination and verification of the property.

5. `Creation of ERC-6551 Account`: Once both the Custodian and Verifier have completed their due diligence and provided their consent, the ProposerAdminContract creates an ERC-6551 account for the NFT, using the details provided during the NFT creation.

6. `Token Generation and Storage: With the ERC-6551 account in place, the Custodian and Verifier generate tokens representing the property. These tokens are tied to the ERC-6551 account and stored within it.

7. `Unlocking the NFT`: After the tokens have been generated and stored in the ERC-6551 account, the NFT is unlocked, making it available for sale.

## GitHub README

The GitHub repository for this project will contain the following sections:

1. `Project Overview`: A brief description of the project, its purpose, and its main features.

2. `Installation`: Instructions on how to set up and run the project locally, including any dependencies that need to be installed.

3. `Usage`: A guide on how to use the application, including step-by-step instructions on how to create an NFT, transfer it to the ProposerAdminContract, and complete the auction process.

4. `Smart Contracts`: Details about the smart contracts used in the project, their functions, and how they interact with each other.

5. `Off-Chain Consent Process`: An explanation of the off-chain consent process involving the Custodian and Verifier, and how their input is integrated into the project.

6. `ERC-6551 Account`: Information about the ERC-6551 standard and how it is utilized to manage the tokens representing the property.

7. `Security Considerations`: Any security measures implemented in the project to ensure the safety of the users and their assets.

8. `Contributing`: Guidelines for contributors who wish to contribute to the project.

9. `License`: The license under which the project is made available.

## Conclusion

The Real Estate Auction Project using ERC-6551 aims to provide a secure and decentralized platform for property owners to sell their properties through a DAO. By leveraging the ERC-6551 standard and involving trusted parties like the Custodian and Verifier, this project ensures a transparent and reliable auction process. Users can follow the GitHub README to participate in the auction or contribute to the development of the project.
