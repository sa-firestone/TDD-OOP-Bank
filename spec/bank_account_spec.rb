#TEST FILE bank_account_spec.rb

require "./bank_account.rb"

describe BankAccount do
    it "can create a new account with a starting balance and an account holder(user)" do
        account = BankAccount.new(500, "Sarah")
        expect(account).to be_a(BankAccount)
    end

    it "can report its balance" do
        account = BankAccount.new(500, "Sarah")
        expect(account.balance).to eq(500)
    end

    it "can deposit funds to an account" do
        account = BankAccount.new(500, "Sarah")
        account.deposit(500)
        expect(account.balance).to eq(1000)
    end

    it "can withdraw funds from an account" do
        account = BankAccount.new(500, "Sarah")
        account.withdraw(200)
        expect(account.balance).to eq(300)
    end

    it "can transfer funds to a different BankAccount(user)" do
        account1 = BankAccount.new(500, "Sarah")
        account2 = BankAccount.new(300, "Clay")
        account1.transfer(100, account2)
        expect(account1.balance).to eq(400)
        expect(account2.balance).to eq(400)
    end

    it "will enforce BankAccounts to be created with a minimum balance" do
        expect { BankAccount.new(100, "Sarah") }.to raise_error(ArgumentError)
    end

    it "Banks can change the minimum balance for all accounts at once" do
        BankAccount.change_minimum_balance(250)
        expect { BankAccount.new(230, "Sarah") }.to raise_error(ArgumentError)
        expect { BankAccount.new(300, "Sarah") }.to_not raise_error(ArgumentError)
    end

    it "can asses overdraft fees when withdrawals result in a negative balance" do
        account = BankAccount.new(300, "Sarah")
        account.withdraw(320)
        expect(account.balance).to eq(-50)
    end

    it "can change the overdraft fee amount for all accounts" do
        BankAccount.change_overdraft_fee(50)
        account = BankAccount.new(300, "Sarah")
        account.withdraw(320)
        expect(account.balance).to eq(-70)
    end

    it "can display a history of transactions" do
        account = BankAccount.new(500, "Sarah")
        account2 = BankAccount.new(500, "Clay")
        account.withdraw(20)
        account.withdraw(50)
        account.deposit(100)
        account.transfer(100, account2)
        expect(account.balance).to eq(430)
        expect(account.history).to match_array(
            [{:transaction_type=>"withdraw", :amount=>20, :balance=>480},
             {:transaction_type=>"withdraw", :amount=>50, :balance=>430},
             {:transaction_type=>"deposit", :amount=>100, :balance=>530},
             {:transaction_type=>"withdraw", :amount=>100, :balance=>430},
             {:transaction_type=>"& transfer", :to=>"Clay", :amount=>100, :balance=>430}]
        )
    end

    it "can write backup data to a file" do
        account = BankAccount.new(500, "Sarah")
        account2 = BankAccount.new(500, "Clay")
        account.deposit(100)
        account.withdraw(50)
        account.transfer(50, account2)
        account.backup 
        file = File.readlines('./bank_account_backup.txt')
        expect(file).to eq(
            [[{:transaction_type=>"deposit", :amount=>100, :balance=>600},
             {:transaction_type=>"withdraw", :amount=>50, :balance=>550},
             {:transaction_type=>"withdraw", :amount=>50, :balance=>500},
             {:transaction_type=>"& transfer", :to=>"Clay", :amount=>50, :balance=>500}].to_s]
        )
    end

end