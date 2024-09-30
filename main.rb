# Por favor envía el link del repositorio de github con el siguiente código: 
# Create a simple Portfolio class that contains a collection of Stock objects and includes a Profit method. 
# This method should accept two dates and return the portfolio’s profit between those dates. 
# Assume that each Stock has a Price method that takes a date as input and returns the stock’s price on that date. 
# Bonus Track: Be able to get the annualized return of the portfolio between the given dates.✱
require 'date'

class Stock
  attr_accessor :name, :price, :stock_values
  def initialize(name)
    @name = name
    @stock_values = Hash.new
    set_prices
  end

  def price(date)
    @stock_values[date]
  end

  def set_prices
    index = 1
    (Date.new(2010, 1, 1)).upto(Date.today).map do |date|
      prev_value = @stock_values[date.prev_day] || 1
      @stock_values[date] = Random.rand(3)+prev_value.to_i
      @stock_values[date] = @stock_values[date]-Random.rand(10) if index != 1 && index % 5 == 0
      index += 1
    end
  end

  def annualized_return(start_date, end_date)
    years = end_date.year - start_date.year
    years = 1 if years < 1
    ar = 0

    start_price = self.price(start_date)
    end_price = self.price(end_date)

    if !(start_price.nil? || end_price.nil?)
      ar = ((end_price/start_price.to_f)**(1/years.to_f))-1
    end
    (ar * 100).round(2)
  end
end

class Portfolio
  attr_accessor :stocks
  def initialize
    @stocks = [Stock.new('AAPL'), Stock.new('GOOGL'), Stock.new('AMZN')]
  end

  def profit(start_date, end_date)

    @stocks.each do |stock|
      start_price = stock.price(start_date)
      end_price = stock.price(end_date)

      if !(start_price.nil? || end_price.nil?)
        total = (end_price - start_price)/(start_price+end_price).to_f * 100
        puts total
      end
    end
  end

  def annualized_return(start_date, end_date)
    years = end_date.year - start_date.year
    years = 1 if years < 1
    stock_ar = 0
    idx = 1
    @stocks.each do |stock|
      stock_ar = stock.annualized_return(start_date, end_date)
      idx += 1
    end
    (stock_ar/idx.to_f).round(2)
  end
end


@portfolio = Portfolio.new
start_date = Date.new(2020, 1, 1)
end_date = Date.new(2024, 1, 1)
@portfolio.stocks.each { |stock|

  puts stock.name
  puts "from #{start_date} ($#{stock.price(start_date)}) to #{end_date} ($#{stock.price(end_date)})"
  puts "#{stock.annualized_return(start_date, end_date)}%"
  puts "----------------------"
}
puts "Portfolio annualized Returns"
puts "from #{start_date}  to #{end_date}"
puts "#{end_date.year - start_date.year} years"
puts "#{@portfolio.annualized_return(start_date, end_date)}%"

