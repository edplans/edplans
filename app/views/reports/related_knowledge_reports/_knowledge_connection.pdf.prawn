if knowledge_connection.is_a?(Guideline)
  pdf.text "#{ knowledge_connection.grade_name }  <font name='FontAwesome'>\uf02e</font>  #{ knowledge_connection.name }", :inline_format => true, :size => 11
else
  pdf.text "#{ knowledge_connection.grade_name } #{ knowledge_connection.name_with_prefix }", :size => 11
end
