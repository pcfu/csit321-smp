require 'io/console'

namespace :admin do
  desc "create admin user account"
  task :create => :environment do
    puts "(Enter 'q' to quit anytime during account creation)"

    admin = User.new(role: :admin)
    get_attribute(admin, :first_name)
    get_attribute(admin, :last_name)
    get_attribute(admin, :email)
    get_password(admin)

    puts "Admin user created" if admin.save
  end
end

def get_attribute(user, attr)
  loop do
    print "Enter #{attr}: "
    user[attr] = gets.chomp
    abort "Quit" if user[attr] == 'q'

    user.valid?
    if user.errors[attr].present?
      puts "#{attr} #{user.errors[attr].first}"
    else
      break
    end
  end
end

def get_password(user)
  loop do
    user.password = IO::console.getpass "Enter password: "
    abort "Quit" if user.password == 'q'

    user.valid?
    if user.errors[:password].present?
      puts "Password #{user.errors[:password].first}"
    else
      break
    end
  end

  loop do
    password_confirmation = IO::console.getpass "Confirm password: "
    abort "Quit" if password_confirmation == 'q'

    if password_confirmation != user.password
      puts "Does not match password"
    else
      break
    end
  end
end
