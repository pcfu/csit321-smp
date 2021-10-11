module LastDateForStockSearchable
  extend ActiveSupport::Concern

  def last_date_for_stock(stock_id: nil, symbol: nil)
    return nil if stock_id.nil? and symbol.nil?

    if stock_id.nil? and symbol.present?
      stock_id = Stock.where(symbol: symbol.upcase).first.try :id
    end
    self.where(stock_id: stock_id).order(date: :desc).first.try :date
  end
end
