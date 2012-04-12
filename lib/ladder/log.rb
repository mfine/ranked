module Ladder
  module Log

    def self.notice(*data, &block)
      message = "file=#{file} fun=#{fun} #{format(*data)}"
      if block
        start = Time.now
        result = yield
        puts "elapsed=#{Time.now - start} #{message}"
        result
      else
        puts message
      end
    end

    def self.file
      caller[1].match(/#{Dir.getwd}\/lib\/([^\.]*)/) && $1.strip
    end

    def self.fun
      caller[1].match(/([^` ]*)'/) && $1.strip
    end

    def self.format(*data)
      data.map do |d|
        case d
        when Hash
          d.map do |k, v|
            case v
            when Hash
              "#{k}=#"
            when NilClass
              "#{k}=nil"
            when Time
              "#{k}=#{v.strftime("%m-%d-%Y:%H:%M:%S")}"
            when Float
              "#{k}=#{format("%.3f", v)}"
            else
              "#{k}=#{v.to_s}"
              end
          end.compact.join(" ")
        else
          d.to_s
        end
      end.compact.join(" ")
    end

    def self.puts(str)
      $stdout.puts str[0,900]
      $stdout.flush
    end
  end
end
