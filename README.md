# Simple Counter Contract Replication

This repository includes a simple counter contract and a counter with a token dependency for replication. The project demonstrates how adding a dependency in the `Nargo.toml` affects the generated TypeScript storage layout in Aztec v0.54.0.

## Folder Structure

- **Counter**: Contains the simple counter contract without any token dependencies.
- **counter-with-token-dependency**: Contains the counter contract with token dependencies added in `Nargo.toml`.

## Instructions

### 1. Compile the Counter Contract

The `Counter` folder includes the simple counter contract. Follow the steps below to compile and generate the TypeScript class:

```bash
aztec-nargo compile
aztec codegen -o src/artifacts target
```
This is the dependencies in the Nargo.toml 

```toml
aztec = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/aztec-nr/aztec" }
value_note = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/aztec-nr/value-note" }
easy_private_state = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/aztec-nr/easy-private-state" }
```

After running these commands, a TypeScript class for the counter contract is generated, with the following storage layout:

```typescript
public static get storage(): ContractStorageLayout<'counters'> {
  return {
    counters: {
      slot: new Fr(1n),
    }
  } as ContractStorageLayout<'counters'>;
}
```

### 2. Compile the Counter Contract with Token Dependency
In the counter-with-token-dependency folder, a token dependency has been added to the Nargo.toml file as shown below:

```toml
[dependencies]
aztec = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/aztec-nr/aztec" }
value_note = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/aztec-nr/value-note" }
easy_private_state = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/aztec-nr/easy-private-state" }
token = { git = "https://github.com/AztecProtocol/aztec-packages/", tag = "aztec-packages-v0.54.0", directory = "noir-projects/noir-contracts/contracts/token_contract" }
```
Without importing the token into the contract, the following dependencies are imported:

```rust
use dep::aztec::prelude::{AztecAddress, Map};
use dep::value_note::{balance_utils, value_note::{ValueNote, VALUE_NOTE_LEN}};
use dep::easy_private_state::EasyPrivateUint;
```

### 3. Generated Storage Layout Comparison
When the token dependency is added, the generated TypeScript class now includes storage slots for the token-related fields, as shown below:

```typescript
public static get storage(): ContractStorageLayout<'admin' | 'minters' | 'balances' | 'total_supply' | 'pending_shields' | 'public_balances' | 'symbol' | 'name' | 'decimals'> {
  return {
    admin: {
      slot: new Fr(1n),
    },
    minters: {
      slot: new Fr(2n),
    },
    balances: {
      slot: new Fr(3n),
    },
    total_supply: {
      slot: new Fr(4n),
    },
    pending_shields: {
      slot: new Fr(5n),
    },
    public_balances: {
      slot: new Fr(6n),
    },
    symbol: {
      slot: new Fr(7n),
    },
    name: {
      slot: new Fr(8n),
    },
    decimals: {
      slot: new Fr(9n),
    }
  } as ContractStorageLayout<'admin' | 'minters' | 'balances' | 'total_supply' | 'pending_shields' | 'public_balances' | 'symbol' | 'name' | 'decimals'>;
}
```

In contrast, the original counter contract without the token dependency only uses a single storage slot for counters which is to be expected.
The only change is to the Nargo.toml


