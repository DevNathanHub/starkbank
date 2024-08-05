#[starknet::interface]
pub trait IStarkBank<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
    fn withdraw_balance(ref self: TContractState, amount: felt252);
}

#[starknet::contract]
mod StarkBank {
    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct DepositEvent {
        amount: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct WithdrawEvent {
        amount: felt252,
    }

    #[abi(embed_v0)]
    impl StarkBankImpl of super::IStarkBank<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'amount must be greater than 0');

            self.balance.write(self.balance.read() + amount);
            self.emit(DepositEvent { amount });
        }

        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }

        fn withdraw_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'amount must be greater than 0');

            self.balance.write(self.balance.read() - amount);
            self.emit(WithdrawEvent { amount });
        }
    }
}
