class Grant < ActiveRecord::Base
  
  has_many :categories
  has_many :costs
  belongs_to :user
  belongs_to :organization
  
  validates_presence_of :name, :user, :organization, :state
  
  alias_attribute :granted, :amount
  
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
  
  def costs_array
    if granted.present?
      
      onces = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::ONCE, starts_at, ends_at] )
      dailies = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::DAILY, starts_at, ends_at] )
      weeklies = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::WEEKLY, starts_at, ends_at] )
      monthlies = Cost.where( ['periodicity = ? AND starts_at >= ? AND ends_at <= ?', Periodicity::MONTHLY, starts_at, ends_at] )
      
      costs_array = []
      
      first_day_of_month = starts_at.to_date.strftime('%-d').to_i
      
      (starts_at.to_date..ends_at.to_date).each_with_index do |day, i|
        total_daily_amount = 0
        
        onces.each do |once|
          if day == once.starts_at.to_date
            total_daily_amount += once.amount
          end
        end
        
        dailies.each do |daily|
          if day >= daily.starts_at.to_date && day <= daily.ends_at.to_date
            total_daily_amount += daily.amount
          end
        end
        
        weeklies.each do |weekly|
          if day >= weekly.starts_at.to_date && day <= weekly.ends_at.to_date
            if i % 7 == 0
              total_daily_amount += weekly.amount
            end
          end
        end
        
        monthlies.each do |monthly|
          if day >= monthly.starts_at.to_date && day <= monthly.ends_at.to_date
            if day.strftime('%-d').to_i == first_day_of_month.to_i
              total_daily_amount += monthly.amount
            end
          end
        end
        
        costs_array << total_daily_amount
      end
      
      amount_available = granted
      output_array = [{(starts_at.to_i * 1000) => amount_available}]
      # output_array = [{starts_at.strftime("%Y-%m-%d") => amount_available}]
      
      (starts_at.to_date..ends_at.to_date).each_with_index do |day, i|
        amount_available -= costs_array[i]
        # output_array << {day.strftime("%Y-%m-%d") => amount_available}
        output_array << {(day.to_time.to_i * 1000) => amount_available} # need to use epoch time * 1k because js time is in milliseconds, not seconds.
      end
      
      output_array
    else
      []
    end
  end
  
end
