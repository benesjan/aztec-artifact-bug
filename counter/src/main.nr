contract Counter {

    use dep::aztec::prelude::{AztecAddress, Map};
    use dep::value_note::{balance_utils, value_note::{ValueNote, VALUE_NOTE_LEN}};
    use dep::easy_private_state::EasyPrivateUint;

    //this seems to act like a map in solidity
    #[aztec(storage)]
    struct Storage {
        counters: Map<AztecAddress, EasyPrivateUint>,
    }

    #[aztec(private)]
    #[aztec(initializer)]
    // We can name our initializer anything we want as long as it's marked as aztec(initializer)
    fn initialize(headstart: u64, owner: AztecAddress, outgoing_viewer: AztecAddress) {
        let counters = storage.counters;
        counters.at(owner).add(headstart, owner, outgoing_viewer);
    }

    #[aztec(private)]
    fn increment(owner: AztecAddress, outgoing_viewer: AztecAddress) {
        dep::aztec::oracle::debug_log::debug_log_format("Incrementing counter for owner {0}", [owner.to_field()]);
        let counters = storage.counters;
        counters.at(owner).add(1, owner, outgoing_viewer);
    }

    unconstrained fn get_counter(owner: AztecAddress) -> pub Field {
        let counters = storage.counters;
        balance_utils::get_balance(counters.at(owner).set)
        //get_balance operates on the owners counter, is this the owner of the contract or who is calling the function?
        //yiedls a provate counter that only the owner can decrpyt. 
    }
}

//checking my understanding
//the owner of the contract is the person who deployed it with the initaliser
//      they can give themselves a headstart which is just more tokens on deployment
//      i still dont understand the difference between owner and outgoing_viewer
//      because it is private it is just someone who can view the counter, it cannot be anyone
//      the why are they not present in the get_counter