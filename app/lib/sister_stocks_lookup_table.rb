class SisterStocksLookupTable
  SISTERS = {
    # Technology
    :AAPL => [ :IBM,  :AMZN ],
    :IBM  => [ :AMZN, :CRM  ],
    :AMZN => [ :CRM,  :INTC ],
    :CRM  => [ :INTC, :CSCO ],
    :INTC => [ :CSCO, :ORCL ],
    :CSCO => [ :ORCL, :AAPL ],
    :ORCL => [ :AAPL, :IBM  ],

    # Energy
    :XOM  => [ :BP,   :SNP  ],
    :BP   => [ :SNP,  :TRP  ],
    :SNP  => [ :TRP,  :COP  ],
    :TRP  => [ :COP,  :DVN  ],
    :COP  => [ :DVN,  :XOM  ],
    :DVN  => [ :XOM,  :BP   ],

    # Healthcare
    :GSK  => [ :PFE,  :JNJ  ],
    :PFE  => [ :JNJ,  :SNY  ],
    :JNJ  => [ :SNY,  :MDT  ],
    :SNY  => [ :MDT,  :BIO  ],
    :MDT  => [ :BIO,  :ABT  ],
    :BIO  => [ :ABT,  :GSK  ],
    :ABT  => [ :GSK,  :PFE  ],
  }
  private_constant :SISTERS

  def self.get(symbol)
    SISTERS[symbol.to_sym.upcase]
  end
end
