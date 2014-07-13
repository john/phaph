class Periodicity
  
  ONCE = 0
  DAILY = 1
  WEEKLY = 2
  FORTNIGHTLY = 3
  MONTHLY = 4
  BIMONTHLY = 5
  QUARTERLY = 6
  BIANNUALLY = 7
  ANNUALLY = 8
  
  def self.options_hash
    { 'Once' => ONCE, 'Daily' => DAILY, 'Weekly' => WEEKLY, 'Fortnightly' => FORTNIGHTLY,
    'Monthly' => MONTHLY, 'Bimonthly' => BIMONTHLY, 'Quarterly' => QUARTERLY, 'Biannually' => BIANNUALLY,
    'Annually' => ANNUALLY }
  end
  
  def self.as_string(constant)
    # hash.key(value) => key
    self.options_hash.key(constant)
  end

end
