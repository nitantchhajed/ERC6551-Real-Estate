pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract PropertyProposerStore {
    receive() external payable {}

    address owner;
    address custodian;
    address verifier;
    uint256 NFTCount;
    mapping(uint256 => NFTDetails) public NFTmapping;

    constructor(address _custodian, address _verifier) {
        owner = msg.sender;
        custodian = _custodian;
        verifier = _verifier;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner allowed");
        _;
    }

    modifier onlyCustodian() {
        require(tx.origin == custodian, "only custodian can call");
        _;
    }

    modifier onlyVerifier() {
        require(tx.origin == verifier, "only verifier can call");
        _;
    }

    struct NFTDetails {
        address NFTContractDetails;
        uint256 tokenID;
        address previousOwner;
        bool custodianApproved;
        bool verifierApproved;
    }
    NFTDetails checkDetails;

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function depositNFT(address _NFTContract, uint256 _tokenCount) external {
        IERC721(_NFTContract).transferFrom(
            msg.sender,
            address(this),
            _tokenCount
        );
        checkDetails.NFTContractDetails = _NFTContract;
        checkDetails.tokenID = _tokenCount;
        checkDetails.previousOwner = msg.sender;
        checkDetails.custodianApproved = false;
        checkDetails.verifierApproved = false;
        NFTmapping[NFTCount] = checkDetails;
        NFTCount++;
    }

    function approveCustodian(uint256 _NFTCount, bool _decision)
        external
        onlyCustodian
    {
        checkDetails = NFTmapping[_NFTCount];
        require(
            checkDetails.NFTContractDetails != address(0),
            "entry does not exist"
        );
        checkDetails.custodianApproved = _decision;
        NFTmapping[_NFTCount] = checkDetails;
    }

    function approveVerifier(uint256 _NFTCount, bool _decision)
        external
        onlyVerifier
    {
        checkDetails = NFTmapping[_NFTCount];
        require(
            checkDetails.NFTContractDetails != address(0),
            "entry does not exist"
        );
        require(
            checkDetails.custodianApproved == true,
            "not custodian approved till now"
        );
        checkDetails.verifierApproved = _decision;
        NFTmapping[_NFTCount] = checkDetails;
    }

    function withdrawNFT(uint256 _NFTCount, address _to) external onlyOwner {
        require(
            checkDetails.custodianApproved == true,
            "no custodian approved till now"
        );
        require(
            checkDetails.verifierApproved == true,
            "no verifier approved till now"
        );
        IERC721(NFTmapping[_NFTCount].NFTContractDetails).transferFrom(
            address(this),
            _to,
            NFTmapping[_NFTCount].tokenID
        );
    }
}
