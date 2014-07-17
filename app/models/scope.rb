class Scope
  
  PRIVATE = 0
  SHARED = 1
  LAB = 2
  PUBLIC = 3
  
  def self.options_hash
    { '--Select scope--' => '', 'Public' => PUBLIC, 'Entire lab' => LAB, 'Shared' => SHARED, 'Private' => PRIVATE }
  end
  
  def self.as_string(constant)
    # hash.key(value) => key
    self.options_hash.key(constant)
  end

end
