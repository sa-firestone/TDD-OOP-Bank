#CLASS FILE bank_account.rb

class BankAccount 
    attr_reader :balance
    attr_reader :history
    attr_reader :user

    @@minimum_balance = 200
    @@overdraft_fee = 30

    def initialize(balance, user)
        if balance < @@minimum_balance
            raise ArgumentError
        end
        
        @balance = balance
        @user = user
        @history = []
    end

    def deposit(amount)
        @balance += amount
        @history.push(
            {:transaction_type=>"deposit", :amount=>amount, :balance=>@balance}
        )
    end

    def withdraw(amount)
        @balance -= amount
        if @balance < 0 
            @balance -= @@overdraft_fee
        end
        @history.push(
            {:transaction_type=>"withdraw", :amount=>amount, :balance=>@balance}
        )
    end

    def transfer(amount, account)
        withdraw(amount)
        account.deposit(amount)
        @history.push(
            {:transaction_type=>"& transfer", :to=>account.user, :amount=>amount, :balance=>@balance}
        )
    end

    def backup
        file = File.open('bank_account_backup.txt', 'w')
        file.print(@history)
        file.close
    end

    def self.change_minimum_balance(amount)
        @@minimum_balance = amount
    end

    def self.change_overdraft_fee(amount)
        @@overdraft_fee = amount 
    end
end