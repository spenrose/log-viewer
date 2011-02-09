require 'log_parser/log_parser'
class Log < ActiveRecord::Base
  has_attached_file :log
  
  LOG_LEVELS = [ "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"]
  
  attr_accessor :events
  attr_accessor :user_defined_level

  def getLogEvents
    filePath = "#{Rails.root}/public#{self.log.url(:original, false)}"
    logger.info "Parsing log file #{filePath}"
    logParser = LogParser.new ("TIMESTAMP [THREAD] LEVEL CLASS - MESSAGE", filePath)
    events = logParser.parseFile
  end

  # Use to get log events that are of a certain above log_level
  # log_level: DEBUG will return log events of level "DEBUG", "INFO", "WARN", "ERROR", "FATAL"
  #log_level: FATAL will return log events of level "FATAL"
  def getRestrictedLogEvents(log_level_input)
    logger.info "Restricting log contents for: " + log_level_input
    #get all the allowed log levels
    allowed_log_levels = self.getAllowedLogLevels(log_level_input)
    allowed_log_events = Array.new

    events = self.getLogEvents
    # get a subset of log events that according to the allowed_log_levels
    events.each do |event|
      if allowed_log_levels.include?(event.level)
        #logger.debug "Found log_event: #{event.to_s} with level #{log_level_input}"
        allowed_log_events << event
      end
    end
    allowed_log_events
  end

  # Use to get allowed log levels for a log_level
  #poosible log levels: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
  # eg: log_level: DEBUG allowed_levels = {DEBUG, INFO, WARN, ERROR, FATAL}
  def getAllowedLogLevels(log_level)
    logger.info "Getting possible log levels above: " + log_level

    allowed_log_levels = case log_level
    when "TRACE" then ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"]
    when "DEBUG" then ["DEBUG", "INFO", "WARN", "ERROR", "FATAL"]
    when "INFO" then ["INFO", "WARN", "ERROR", "FATAL"]
    when "WARN" then ["WARN", "ERROR", "FATAL"]
    when "ERROR" then ["ERROR", "FATAL"]
    when "FATAL" then ["FATAL"]
    end
    logger.info "Possible log levels are: " + allowed_log_levels.to_s
    allowed_log_levels

  end
  
  
end

