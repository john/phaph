class Grant < ActiveRecord::Base
  
  belongs_to :creator, class_name: "User"
  belongs_to :lab
  has_many :categories
  has_many :costs
  
  alias_attribute :granted, :amount
  
  validates :name, presence: true
  validates :creator_id, presence: true
  validates :lab_id, presence: true
  
  STATES = [:active, :inactive]
  state_machine :state, :initial => :active do
    event :deactivate do transition STATES => :inactive end
    event :activate do transition STATES => :active end
  end
  
  def people
    Membership.where( :belongable_id => id, :belongable_type => Grant.to_s ).map{|membership| membership.user}
  end
  
  def amount_remaining
    if granted.present?
      spent = 0
      costs.each do |c|
        spent += c.amount
      end
    
      granted - spent
    else
      0
    end
  end
  
  def graph_expenditures
    if granted.present?
      
      dailies = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::DAILY, starts_at, ends_at] )
      weeklies = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::WEEKLY, starts_at, ends_at] )
      monthlies = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::MONTHLY, starts_at, ends_at] )
      
      puts "dailies: #{dailies.size}"
      puts "monthlies: #{monthlies.size}"
      
      
      costs_array = []

      first_day_of_month = starts_at.to_date.strftime('%-d').to_i
      
      (starts_at.to_date..ends_at.to_date).each_with_index do |day, i|
        total_daily_amount = 0
        
        # daily costs
        dailies.each do |daily|
          # puts "IN DAILY"
          if day >= daily.starts_at.to_date &&
              day <= daily.ends_at.to_date
            total_daily_amount += daily.amount
          end
        end
        
        monthlies.each do |monthly|
          # puts "monthly.starts_at.to_date: #{monthly.starts_at.to_date}"
          # puts "day: #{day}"
          # puts "--"
          if day >= monthly.starts_at.to_date && day <= monthly.ends_at.to_date
            # puts "IN MONTHLY, #{day.strftime('%-d').to_i}, #{first_day_of_month.to_i}"
            if day.strftime('%-d').to_i == first_day_of_month.to_i
              # puts "DAY MATCHED: #{monthly.amount}"
              total_daily_amount += monthly.amount
            end
          end
        end
        
        # puts "day: #{day.strftime('%-d')}: #{total_daily_amount}"
        costs_array << total_daily_amount
        
      end
      
      amount_available = granted
      output_array = []
      (starts_at.to_date..ends_at.to_date).each_with_index do |day, i|
        amount_available -= costs_array[i]
        output_array << {day.strftime("%Y-%m-%d") => amount_available}
      end
      
      
      
      # Clone costs into a local array
      # Calculate payment dates for each cost
      
      # You should end up with an array of hashes, with dates as keys,
      #   and total payments on that day as values: [{'2014-04-03' => $600}, {'2014-04-04' => 0} ...]
      
      
      
      
      # Create empty output hash: out = {}
      # Get number of days in grant
      # Iterate through them
        
        # Check if there's a cost on that day
          # Yes: deduct cost from total
          # No: don't do that
          # Append that date to the output array, with date as key and money remaining as value
      output_array
    else
      0
    end
  end
  
end
