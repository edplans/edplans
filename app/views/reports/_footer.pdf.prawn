pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 25], :width  => pdf.bounds.width do
  pdf.stroke_horizontal_rule
  pdf.move_down(5)
  pdf.text t('.copyright'), :size => 10
end
