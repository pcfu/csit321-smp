FactoryBot.define do
  factory :user, aliases: [:john] do
    transient do
      base_password { 'P@ssw5rd' }
    end

    first_name            { 'john' }
    last_name             { 'doe' }
    email                 { 'jon.d@email.com' }
    password              { base_password }
    password_confirmation { password }
    role                  { 'regular' }

    factory :control_user, aliases: [:admin] do
      email { 'admin@email.com' }
      role  { 'admin' }
    end

    factory :invalid_user do
      first_name_with_spaces
      last_name_with_number
      email_no_username
      pw_too_short
      pw_not_equal_confirmation
    end


    ### first_name traits

    trait :first_name_with_spaces do
      first_name { 'j o h n' }
    end

    trait :first_name_with_number do
      first_name { 'john1' }
    end

    trait :first_name_uppercase do
      after(:stub) do |user, evaluator|
        user.first_name.upcase!
      end
    end

    ### last_name traits

    trait :last_name_with_spaces do
      last_name { 'd o e' }
    end

    trait :last_name_with_number do
      last_name { 'doe1' }
    end

    trait :last_name_uppercase do
      after(:stub) do |user, evaluator|
        user.last_name.upcase!
      end
    end

    ### email traits

    trait :email_with_spaces do
      email { 'john d@email.com'}
    end

    trait :email_no_username do
      email { '@email.com' }
    end

    trait :email_no_at_symbol do
      email { 'john.d#email.com' }
    end

    trait :email_no_domain_name do
      email { 'john.d@.com' }
    end

    trait :email_no_top_level_domain do
      email { 'john.d@email'}
    end

    trait :email_uppercase do
      after(:stub) do |user, evaluator|
        user.email.upcase!
      end
    end

    ### password traits

    trait :pw_too_short do
      password { base_password[...-1] }
    end

    trait :pw_too_long do
      password do
        extra_len = User::PW_MAX_LEN - base_password.length + 1
        base_password + 'a' * extra_len
      end
    end

    trait :pw_with_spaces do
      password { 'P @ s s w 5 r d' }
    end

    trait :pw_lowercase do
      password { base_password.downcase }
    end

    trait :pw_uppercase do
      password { base_password.upcase }
    end

    trait :pw_no_numbers do
      password { 'P@ssword' }
    end

    trait :pw_no_special_chars do
      password { 'Passw0rd' }
    end

    trait :new_password do
      password              { 'p@55worD' }
      password_confirmation { 'p@55worD' }
    end

    ### password_confirmation traits

    trait :pw_not_equal_confirmation do
      password_confirmation { 'P@55w0rd' }
    end

    ### role traits

    trait :invalid_role do
      role { 'invalid' }  # throws error on initialization!
    end
  end
end
