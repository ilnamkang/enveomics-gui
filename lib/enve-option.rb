class EnveOption
   # Class-level
   @@TYPE = {
      nil: {name: ""},
      task: {name: "Script"},
      in_file: {name: "Input file"},
      out_file: {name: "Output file"},
      in_dir: {name: "Input directory"},
      out_dir: {name: "Output directory"},
      select: {name: "Select"},
      string: {name: "String"},
      character: {name: "Character"},
      integer: {name: "Integer"},
      float: {name: "Floating-point number"}
   }
   def self.TYPE
      @@TYPE
   end
   # Instance-level
   attr_accessor :hash
   def initialize(o)
      if o.is_a? Hash
	 @hash = o
      elsif o.is_a? String
	 @hash = {hidden:true, opt:o, arg: :nil, as_is:true}
      else
	 raise "Unsupported object to initialize EnveOption: #{o.class}."
      end
      @hash[:arg] = @hash[:arg].nil? ? :nil : @hash[:arg].to_sym
      @hash[:hidden] = true if @hash[:arg]==:task
      raise "Unknown argument type: #{@hash[:arg]}." if
	 @@TYPE[ @hash[:arg].to_sym ].nil?
      if @hash[:name].nil?
	 if @hash[:opt].nil?
	    @hash[:name] = @@TYPE[ @hash[:arg].to_sym ][:name]
	 else
	    @hash[:name] = hash[:opt].sub(/^-+/,"").gsub(/[-_]/," ").capitalize
	 end
      end
      @hash[:description] = @hash[:description].join(" ") if
	 @hash[:description].is_a? Array
      @hash[:note] = @hash[:note].join(" ") if @hash[:note].is_a? Array
      @hash[:description] ||= ""
   end
   def name
      hash[:name].to_s + (mandatory? ? "*" : "")
   end
   def description
      hash[:description].to_s
   end
   def note
      hash[:note].to_s
   end
   def opt
      hash[:opt]
   end
   def arg
      @hash[:arg] ||= :nil
      hash[:arg].to_sym
   end
   def multiple_sep
      hash[:multiple_sep]
   end
   def values
      raise "Options of 'select' type must contain a 'values' array: " +
	 "#{name}." unless arg==:select and hash[:values].is_a? Array
      hash[:values]
   end
   def default
      hash[:default]
   end
   def source_urls
      @hash[:source_url] ||= []
      @hash[:source_url] = [hash[:source_url]] unless
	 hash[:source_url].is_a? Array
      hash[:source_url]
   end
   def hidden?
      !!hash[:hidden]
   end
   def mandatory?
      !!hash[:mandatory]
   end
   def as_is?
      !!hash[:as_is]
   end
end

