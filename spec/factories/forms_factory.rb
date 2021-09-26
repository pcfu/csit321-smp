FactoryBot.define do
  factory :registration_form, class: Hash do
    title         { "Create an account" }
    fields        {[
      { field: :user_first_name, label: 'FIRST NAME' },
      { field: :user_last_name, label: 'LAST NAME' },
      { field: :user_email, label: 'EMAIL' },
      { field: :user_password, label: 'PASSWORD' },
      { field: :user_password_confirmation, label: 'PASSWORD CONFIRMATION' },
    ]}
    submit        { 'Register' }
    have_account  { "Already have an account?" }

    initialize_with { attributes }
  end
end
