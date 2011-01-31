require 'log_parser/log_parser'
class Log < ActiveRecord::Base
  has_attached_file :log
  
  attr_accessor :logContents
  
  def logContents
    filePath = "#{Rails.root}/public#{self.log.url(:original, false)}"
    logParser = LogParser.new ("TIMESTAMP [THREAD] LEVEL CLASS - MESSAGE", filePath)
    log_events = logParser.parseFile
  
    self.logContents = log_events
    
    #fileStr = ""
    #File.open("#{Rails.root}/public#{self.log.url(:original, false)}", "r") do |file|
    #  while line = file.gets
    #    fileStr += line
    #  end
    #end
    #self.logContents = fileStr
  end
end

