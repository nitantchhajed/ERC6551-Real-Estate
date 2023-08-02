pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface PropertyProposerStore {
    function approveCustodian(uint256 _NFTCount, bool _decision) external;
}

contract custodianController is ERC721 {
    uint256 public tokenCount;
    address public custodian;
    address propertyProposer;

    constructor() public ERC721("Custodian Approval", "CUSTApproved") {
        custodian = msg.sender;
    }

    mapping(uint256 => bool) public isGivenApproval;

    modifier onlyCustodian() {
        require(msg.sender == custodian, "only custodian can call");
        _;
    }

    function changeCustodian(address _newCustodian) public onlyCustodian {
        custodian = _newCustodian;
    }

    function setPropertyProposer(address _proposer) public onlyCustodian {
        propertyProposer = _proposer;
    }

    function mintApproval(
        address _to,
        uint256 _NFTCount,
        bool _decision
    ) public onlyCustodian {
        _mint(_to, tokenCount);
        tokenCount++;
        PropertyProposerStore(propertyProposer).approveCustodian(
            _NFTCount,
            _decision
        );
        isGivenApproval[_NFTCount] = _decision;
    }
}
