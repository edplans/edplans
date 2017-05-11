begin_tag = if domain.is_course_unit?
              "<i>"
            elsif domain.is_custom?
              "<u>"
            else
              ""
            end

end_tag = begin_tag.gsub("<", "</")


pdf.make_cell :content => "#{ begin_tag }#{ domain.name }#{ end_tag }", :inline_format => true
