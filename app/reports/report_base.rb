class ReportBase

  class_attribute :_report_attrs
  
  class << self
    
    def report_attr(name)
      attr_accessor name
      self._report_attrs = ((_report_attrs || []) << name)
    end
    
    def report_attrs(*names)
      names.each {|name| report_attr(name)}
    end

  end

  def initialize(opts = {})
    _report_attrs.each { |name| send "#{ name }=", opts[name] }
  end

end
