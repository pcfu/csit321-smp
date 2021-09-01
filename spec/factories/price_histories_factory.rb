FactoryBot.define do
  factory :price_history do
    transient do
      prc_open  { 100.0 }
      prc_close { 100.5 }
    end

    date    { '2021-01-01' }
    open    { prc_open }
    high    { 101.0 }
    low     { 99.0 }
    close   { prc_close }
    volume  { 123456789 }
    change  { prc_close - prc_open }
    percent_change  { (prc_close - prc_open) / 100 }


    factory :ctrl_history do
      transient do
        ctrl_open   { prc_close }
        ctrl_close  { 98.7 }
      end

      date    { '2021-01-02' }
      open    { ctrl_open }
      high    { 105.0 }
      low     { 95.0 }
      close   { ctrl_close }
      volume  { 123456789 }
      change  { ctrl_close - ctrl_open }
      percent_change  { (ctrl_close - ctrl_open) / 100 }
    end
  end
end
