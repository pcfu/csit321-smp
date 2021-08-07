FactoryBot.define do
  factory :stock, aliases: [:base_stock, :google] do
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

    trait :symbol_lowercase do
      symbol { 'goog' }
    end
  end
end
