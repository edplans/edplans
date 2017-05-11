class String

  def remove_non_pdf_tags
    self.gsub(/<li>/, "\n").
      gsub(/<br>/, "\n").
      gsub(/<\/?(h|br|div|ul|li|ol|blockquote|span)\d*\/?>/, '').
      gsub('&nbsp;', ' ').
      strip
  end

end
    
class NilClass

  def remove_non_pdf_tags
    ""
  end

end
