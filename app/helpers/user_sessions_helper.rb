module UserSessionsHelper

  def first_planner_signin_text
    str = <<EOF

<p>Because you are the first Planner in your school, we ask that you complete the tasks below before inviting others.</p>

<p>On the page below, enter...</p>

<ol>
<li>School Name</li>
<li>School Year, first day for students</li>
<li>School Year, last day for students</li>
<li>Grades offered at your school<br/>
Click on the button 'Update'.</li>

<li>Holidays and Non-Instructional Days (no students). If you are short on time you can skip this task and return to it later... or ask another Planner to add the holidays.</li>
</ol>

<p>Now you are ready to invite other Planners and begin planning the school curriculum.<p>
EOF
  end

end
