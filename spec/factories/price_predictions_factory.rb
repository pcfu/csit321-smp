FactoryBot.define do
  factory :price_prediction do
    transient do
      base_date { Date.new(2021, 1, 1) }
      base_nd   { 10.00 }
      base_st   { 20.00 }
      base_md   { 35.00 }
      base_lt   { 50.00 }
    end

    entry_date    { base_date }
    nd_date       { base_date.advance(days: 1) }
    nd_min_price  { base_nd * 0.9 }
    nd_exp_price  { base_nd }
    nd_max_price  { base_nd * 1.0 }
    st_date       { base_date.advance(days: PricePrediction::ST_DAYS) }
    st_min_price  { base_st * 0.9 }
    st_exp_price  { base_st }
    st_max_price  { base_st * 1.1 }
    mt_date       { base_date.advance(days: PricePrediction::MT_DAYS) }
    mt_min_price  { base_md * 0.9 }
    mt_exp_price  { base_md }
    mt_max_price  { base_md * 1.1 }
    lt_date       { base_date.advance(days: PricePrediction::LT_DAYS) }
    lt_min_price  { base_lt * 0.9 }
    lt_exp_price  { base_lt }
    lt_max_price  { base_lt * 1.1 }


    ### date traits

    trait :entry_date_nil do
      entry_date { nil }
    end

    trait :nd_date_nil do
      nd_date { nil }
    end

    trait :st_date_nil do
      st_date { nil }
    end

    trait :mt_date_nil do
      mt_date { nil }
    end

    trait :lt_date_nil do
      lt_date { nil }
    end
  end
end
