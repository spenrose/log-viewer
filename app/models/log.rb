class Log < ActiveRecord::Base
  has_attached_file :log
  
  attr_accessor :logContents
  
  def logContents
    fileStr = ""
    File.open("#{Rails.root}/public#{self.log.url(:original, false)}", "r") do |file|
      while line = file.gets
        if(line =~ /==+/)
          fileStr += "<span class=\"highlight\">#{line}</span>"
        elsif (file.lineno % 2 == 0)
          fileStr += "<span class=\""+ "list_line_odd" + "\">#{line}</span>"
        else
          fileStr += "<span class=\""+ "list_line_even" + "\">#{line}</span>"
        end
        fileStr += "<br>"
      end
    end
    self.logContents = fileStr
  end
end

