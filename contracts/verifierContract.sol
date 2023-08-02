pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface PropertyProposerStore {
    function approveVerifier(uint256 _NFTCount, bool _decision) external;
}

contract verifierController is ERC721 {
    uint256 public tokenCount;
    address public verifier;
    address propertyProposer;

    constructor() public ERC721("Verifier Approval", "VeriApproved") {
        verifier = msg.sender;
    }

    mapping(uint256 => bool) public isGivenApproval;

    modifier onlyVerifier() {
        require(msg.sender == verifier, "only verifier can call");
        _;
    }

    function changeCustodian(address _newVerifier) public onlyVerifier {
        verifier = _newVerifier;
    }

    function setPropertyProposer(address _proposer) public onlyVerifier {
        propertyProposer = _proposer;
    }

    function mintApproval(
        address _to,
        uint256 _NFTCount,
        bool _decision
    ) public onlyVerifier {
        _mint(_to, tokenCount);
        tokenCount++;
        PropertyProposerStore(propertyProposer).approveVerifier(
            _NFTCount,
            _decision
        );
        isGivenApproval[_NFTCount] = _decision;
    }
}
