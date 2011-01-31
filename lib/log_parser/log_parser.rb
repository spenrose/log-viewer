require 'log_parser/log_event'

class LogParser
  
  # logFormat = TIMESTAMP, LOGGER, LEVEL, THREAD, CLASS, FILE, LINE, METHOD, RELATIVETIME, MESSAGE, NDC, PROP(key)
  def initialize(logFormat, filePath)
    @logFormat = logFormat
    @filePath = filePath
  end
  
  def parseFile
    # Create regex 
    regex = createRegex
    
    # Save each log entry in this array of LogEvent
    log_events = Array.new
    
    # Open file and parse contents into LogEvent
    begin
      File.open(@filePath, "r") do |file|
        log_event = nil
      
        while line = file.gets
        
          # If this line is the start of a new LogEvent if it matches the Regex
          if ( line =~ /^#{regex}/ )
          
            # Add previous LogEvent to array 
            if !log_event.nil?
              log_events << log_event
            end
          
            # Create new LogEvent
            log_event = LogEvent.new
            log_event.message = line
          
            # Parse each grouping from Regex to add to LogEvent
            count = 0
            @groupOrder.each do |group|
              count = count + 1
              case group
              when "TIMESTAMP"
                log_event.timestamp = eval("$#{count}").strip
              when "LEVEL"
                log_event.level = eval("$#{count}").strip
              when "THREAD"
                log_event.thread = eval("$#{count}").strip
              when "CLASS"
                log_event.log_class = eval("$#{count}").strip
              when "MESSAGE"
                log_event.message = eval("$#{count}")
              end
            end
          else # Not a new LogEvent. Continuation of message to new line. Append to LogEvent
            if !log_event.nil?
              log_event.message << line
            end
          end
        end
      
        # Add last LogEvent to array
        if !log_event.nil?
          log_events << log_event
        end
      end
    rescue Errno::ENOENT => e
      puts "Could not open file. #{e.message}. #{e.backtrace}"
    end
  end
  
  private
  
  def createRegex
    regex = @logFormat
    @groupOrder = Array.new
    
    #clean up
    regex.gsub!(/\s/, "\\s")
    regex.gsub!(/\[/, "\\[")
    regex.gsub!(/\]/, "\\]")
    regex.gsub!(/\(/, "\\(")
    regex.gsub!(/\)/, "\\)")
    regex.gsub!(/\{/, "\\{")
    regex.gsub!(/\}/, "\\}")
    regex.gsub!(/\+/, "\\+")
    regex.gsub!(/\?/, "\\?")
    regex.gsub!(/\./, "\\.")
    regex.gsub!(/\*/, "\\*")
    regex.gsub!(/\^/, "\\^")
    regex.gsub!(/\$/, "\\$")
    regex.gsub!(/\|/, "\\|")
    regex.gsub!(/\\/, "\\\\")
    
    #Timestamp
    timestampRegex = timestampRegex()
    regex.gsub!(/TIMESTAMP/, "(#{timestampRegex})")
    @groupOrder << "TIMESTAMP"
    
    # Logger
    
    # Level
    levelRegex = levelRegex()
    regex.gsub!(/LEVEL/, "(#{levelRegex})")
    @groupOrder << "LEVEL"
    
    # Thread
    regex.gsub!(/THREAD/, "(.*)")
    @groupOrder << "THREAD"
    
    # Class
    regex.gsub!(/CLASS/, "(.*)")
    @groupOrder << "CLASS"
    
    # File
    
    # Line
    
    # Method
    
    # Relativetime
    
    # Message 
    regex.gsub!(/MESSAGE/, "(.*)")
    @groupOrder << "MESSAGE"
    
    # NDC
    
    # Prop(key)
    
    regex
  end
  
  def timestampRegex
    #timestampRegex = ""
    #@timestampFormat.each_char do |c|
    #  if ( c =~ /d|h|y|[Mm]|[Ss]/ )
    #    timestampRegex << "\\d"
    #  elsif ( c =~ /\s/)
    #    timestampRegex << "\\s"
    #  else
    #    timestampRegex << c
    #  end
    #end
    timestampRegex = "\\d{4}-\\d{2}-\\d{2}\\s\\d{2}:\\d{2}:\\d{2},\\d{3}"
  end
  
  def levelRegex
    # TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    regex = "TRACE|DEBUG|INFO|WARN|ERROR|FATAL"
  end
    
  
end