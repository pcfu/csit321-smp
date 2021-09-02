FactoryBot.define do
  factory :model_config, aliases: [ :full_trained ] do
    name          { "price prediction model configuration" }
    params        { "{\"n_layers\": 3}" }
    train_percent { 100 }

    factory :ctrl_config, aliases: [ :half_trained ] do
      name          { "stock recommendation model configuration" }
      params        { "{\"n_nodes\": 100}" }
      train_percent { 50 }
    end

    factory :untrained do
      name          { "untrained model configuration "}
      train_percent { 0 }
    end


    ### params traits

    trait :params_invalid_json do
      params { "invalid" }
    end

    trait :params_string do
      params { "\"string\"" }
    end

    trait :params_integer do
      params { "1" }
    end

    trait :params_array do
      params { "[]" }
    end

    trait :params_empty_hash do
      params { "{}" }
    end

    ### train_percent traits

    trait :train_percent_under_0 do
      train_percent { -1 }
    end

    trait :train_percent_above_100 do
      train_percent { 101 }
    end
  end
end
