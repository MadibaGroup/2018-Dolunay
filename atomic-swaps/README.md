# Atomic Swaps

A collection of implementations of atomic swap smart contracts for Ethereum written in Solidity. An atomic swap is a swap where either both sides of the swap happen, or neither. The risk of one party losing their assets is minimized.

Our current implementations include:
* ETHtoERC20.sol
  - This contract allows for atomic swaps between Ethereum (ETH) and any ERC20 compliant token.
* ERC20toERC20.sol
  - This contract allows for atomic swaps between any pair of ERC20 compliant tokens.
    
Once deployed, our swap contracts can be reused across multiple swaps including different ERC20 compliant tokens by including a `swapID`. Currently, these swaps expire after 24 hours of being initialized to minimize exposure to volatility in exchange rates. This is subject to change in the future, including allowing for the expiration date to be chosen when a swap is initialized.
