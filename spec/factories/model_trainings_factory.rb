FactoryBot.define do
  factory :model_training, aliases: [:minimum_training, :initial_training] do
    date_start  { Date.parse("2020-01-01") }
    date_end    { Date.parse("2021-01-01") }
    stage       { :requested }

    factory :ctrl_training, aliases: [:full_training, :completed_training] do
      date_start  { Date.parse("2019-01-01") }
      date_end    { Date.parse("2020-01-01") }
      stage       { :done }
      rmse        { 1.0 }
    end

    factory :rmse_negative do
      stage         { :done }
      rmse          { -0.001 }
      error_message { nil}
    end

    factory :error_with_no_message do
      stage         { :error }
      rmse          { nil }
      error_message { nil }
    end


    ### stage traits

    trait :requested do
      stage { :requested }
    end

    trait :enqueued do
      stage   { :enqueued }
    end

    trait :training do
      stage   { :training }
    end

    trait :done do
      stage   { :done }
      rmse    { 1.0 }
    end

    trait :error do
      stage         { :error }
      error_message { 'unknown error occurred' }
    end

    ### throws error on initialization!

    trait :invalid do
      stage { :invalid }
    end
  end
end
