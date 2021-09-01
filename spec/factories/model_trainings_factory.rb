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


    ### date traits

    trait :date_end_before_date_start do
      date_start  { Date.parse("2020-01-01") }
      date_end    { date_start.advance(days: -1) }
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

    trait :invalid_stage do
      stage { :invalid }
    end

    ### rmse traits

    trait :rmse_nil do
      stage { :done }
      rmse  { nil }
    end

    trait :rmse_negative do
      stage { :done }
      rmse  { -0.001 }
    end

    ### error_message traits

    trait :error_with_no_message do
      stage         { :error }
      error_message { nil }
    end

  end
end
