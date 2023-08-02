pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Create2.sol";
import "./IERC6551Registry.sol";

//import "./ERC6551Account.sol";
//import "./IERC6551Account.sol";
//0x1023fA8296A26482062F04D634ed4b3d56ac7b89
interface IERC6551Account {
    function executeCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable returns (bytes memory);

    function owner() external returns (address);

    function token()
        external
        view
        returns (
            uint256 chainId,
            address tokenContract,
            uint256 tokenId
        );
}

contract ERC6551Registry is IERC6551Registry {
    error InitializationFailed();
    address public accountAddr;

    function createAccount(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt,
        bytes calldata initData
    ) external returns (address) {
        bytes memory code = _creationCode(
            implementation,
            chainId,
            tokenContract,
            tokenId,
            salt
        );

        address _account = Create2.computeAddress(
            bytes32(salt),
            keccak256(code)
        );

        if (_account.code.length != 0) return _account;

        _account = Create2.deploy(0, bytes32(salt), code);

        if (initData.length != 0) {
            (bool success, ) = _account.call(initData);
            if (!success) revert InitializationFailed();
        }

        emit AccountCreated(
            _account,
            implementation,
            chainId,
            tokenContract,
            tokenId,
            salt
        );
        accountAddr = _account;
        return _account;
    }

    function account(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    ) external view returns (address) {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );

        return Create2.computeAddress(bytes32(salt), bytecodeHash);
    }

    function _creationCode(
        address implementation_,
        uint256 chainId_,
        address tokenContract_,
        uint256 tokenId_,
        uint256 salt_
    ) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                hex"3d60ad80600a3d3981f3363d3d373d3d3d363d73",
                implementation_,
                hex"5af43d82803e903d91602b57fd5bf3",
                abi.encode(salt_, chainId_, tokenContract_, tokenId_)
            );
    }

    function executeCallAccount(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable returns (bytes memory result) {
        result = IERC6551Account(accountAddr).executeCall(to, value, data);
    }

    function checkOwnerAccount() public returns (address) {
        return IERC6551Account(accountAddr).owner();
    }

    function checkTokenInfo()
        external
        view
        returns (
            uint256 chainId,
            address tokenContract,
            uint256 tokenId
        )
    {
        (chainId, tokenContract, tokenId) = IERC6551Account(accountAddr)
            .token();
    }
}
