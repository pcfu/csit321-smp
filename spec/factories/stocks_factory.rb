FactoryBot.define do
  factory :stock, aliases: [:google] do
    symbol      { 'GOOG' }
    name        { "Alphabet Inc - Class C" }
    exchange    { "NAS" }
    stock_type  { "cs" }
    description { "Alphabet Inc. is an American multinational conglomerate " +
                  "headquartered in Mountain View, California" }

    factory :ctrl_stock, aliases: [:facebook] do
      symbol      { 'FB' }
      name        { "Facebook Inc - Class A" }
      exchange    { "NAS" }
      stock_type  { "cs" }
      description { "Facebook is a website which allows users, who sign-up for free profiles, " +
                    "to connect with friends, work colleagues or people they don't know, online" }
    end

    factory :boilerplate_stock do
      sequence(:symbol)       {|n| "BOIL#{n}"}
      sequence(:name)         {|n| "Boilerplate stock #{n}"}
      sequence(:description)  {|n| "Generate boilerplate stocks starting at index 1"}
    end

    trait :symbol_lowercase do
      symbol { 'goog' }
    end
  end
end
