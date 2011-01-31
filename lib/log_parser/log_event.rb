class LogEvent
  attr_accessor :timestamp, :level, :thread, :log_class, :message
  
  #def to_json(*a)
  #  {
  #    'json_class'   => self.class.name, # = 'LogEvent'
  #    'data'         => [ timestamp, level, thread, log_class, message ]
  #  }.to_json(*a)
  #end
  #   
  #def self.json_create(o)
  #  new(*o['data'])
  #end
  
  def to_s
    "Timestamp: #{timestamp}. Level: #{level}. Thread: #{thread}. Class: #{log_class}. Message: #{message}"
  end
end