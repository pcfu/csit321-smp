class SisterStocksLookupTable
  SISTERS = {
    :AAPL => [ :IBM,  :AMZN ],
    :IBM  => [ :AAPL, :AMZN ],
    :AMZN => [ :AAPL, :IBM  ],
  }
  private_constant :SISTERS

  def self.get(symbol)
    SISTERS[symbol.to_sym.upcase]
  end
end
