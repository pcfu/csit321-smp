FactoryBot.define do
  factory :user, aliases: [:john] do
    first_name            { "john" }
    last_name             { "doe" }
    email                 { "jon.d@email.com" }
    password              { 'P@ssw5rd' }
    password_confirmation { 'P@ssw5rd' }
  end
end
