class Reports::Base

  cattr_accessor(:report_attrs) { [] }

  class << self
    
    def report_attr(name)
      attr_accessor name
      report_attrs << name
    end
    
    def report_attrs(*names)
      names.each {|name| report_attr(name)}
    end

  end

  def initialize(opts = {})
    report_attrs.each { |name| self.send("#{ name }=", opts[name]) }
  end

end
