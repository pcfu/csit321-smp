FactoryBot.define do
  factory :training_schedule do
    model_config { nil }
    start_date { "2021-10-26" }
    frequency { 1 }
  end
end
