FactoryBot.define do
  factory :model_training, aliases: [:minimum_training] do
    date_start  { Date.parse("2020-01-01") }
    date_end    { Date.parse("2021-01-01") }
    stage       { :requested }

    factory :ctrl_training, aliases: [:full_training, :completed_training] do
      date_start  { Date.parse("2019-01-01") }
      date_end    { Date.parse("2020-01-01") }
      stage       { :done }
      rmse        { 1.0 }
      job_id      { 'aaaaaaaa-1111-2222-3333-bbbbbbbbbbbb' }
    end

    ### stage traits

    trait :requested do
      stage { :requested }
    end

    trait :enqueued do
      stage   { :enqueued }
      job_id  { 'aaaaaaaa-1111-2222-3333-bbbbbbbbbbbb' }
    end

    trait :training do
      stage   { :training }
      job_id  { 'aaaaaaaa-1111-2222-3333-bbbbbbbbbbbb' }
    end

    trait :done do
      stage   { :done }
      rmse    { 1.0 }
      job_id  { 'aaaaaaaa-1111-2222-3333-bbbbbbbbbbbb' }
    end

    trait :error do
      stage         { :error }
      error_message { 'unknown error occurred' }
    end

    trait :error_with_no_message do
      stage         { :error }
      error_message { nil }
    end

    ### rmse traits

    trait :rmse_negative do
      rmse  { -0.001 }
    end
  end
end
