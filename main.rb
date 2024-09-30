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

class Application
  def initialize
    @portfolio = Portfolio.new
    @start_date = nil
    @end_date = nil
    while @start_date.nil? || @end_date.nil?
      get_dates
    end
    while true
      menu
    end
  end

  def get_dates
    puts "Ingresa fecha de inicio (DD/MM/YYYY)"
    sdate = gets.chomp
    puts "Ingresa fecha de termino (DD/MM/YYYY)"
    edate = gets.chomp

    sdate_a = sdate.split('/')
    edate_a = edate.split('/')

    if sdate_a.length != 3
      @start_date = Date.new(2010, 1, 1) 
    else
      @start_date = Date.new(sdate_a[2].to_i, sdate_a[1].to_i, sdate_a[0].to_i)
    end
    if edate_a.length != 3
      @end_date = Date.today 
    else
      @end_date = Date.new(edate_a[2].to_i, edate_a[1].to_i, edate_a[0].to_i)
    end
  end

  def menu
    puts "----------------------"
    puts "Portfolio v0.1"
    puts "----------------------"
    puts "Inicio: #{@start_date}" if !@start_date.nil?
    puts "Termino: #{@end_date}" if !@start_date.nil?
    puts "----------------------"
    puts "1. Calcular rendimiento"
    puts "2. Listar acciones"
    puts "3. Cambiar Fechas"
    puts "4. Salir"
    puts "----------------------"

    option = gets.chomp.to_i
    case option
    when 1
      run_performance
      gets
    when 2
      @portfolio.stocks.each { |stock|
        puts "#{stock.name} - $#{stock.price(Date.today)}" 
      }
      gets
    when 3
      get_dates
    when 4
      exit
    end
  end

  def run_performance
    @portfolio.stocks.each { |stock|

      puts stock.name
      puts "from #{@start_date} ($#{stock.price(@start_date)}) to #{@end_date} ($#{stock.price(@end_date)})"
      puts "#{stock.annualized_return(@start_date, @end_date)}%"
      puts "----------------------"
    }
    puts "Portfolio annualized Returns"
    puts "from #{@start_date}  to #{@end_date}"
    puts "#{@end_date.year - @start_date.year} years"
    puts "#{@portfolio.annualized_return(@start_date, @end_date)}%"
  end
end

Application.new

