# -*- coding: utf-8 -*-
module Teachers::LessonPlansHelper

  PLACEHOLDERS = {
    :ongoing_assessment => "Describe your product and/or performance assessment. You may wish to include an indication of whether the items are formative, summative, or other; a description of the assessment; and/or a list of your comprehension questions. Be sure to align your assessment(s) directly to your objectives.",
    :criteria_for_success => "Describe the specific criteria that determine whether or not a student was successful on the assessment. If your assessment captures only correct versus incorrect answers (e.g., factual recall of correct answers), you do not need to define the CFS and you may leave this field blank.",
    :description => "Write a sentence that states the central idea of the domain",
    :content_objectives => "List the Core Knowledge content objectives for this lesson. These objectives can be found in the Teacher Handbook and are derived directly from the Core Knowledge Sequence. They outline what key knowledge students will acquire during the lesson.",
    :language_art_objectives => "List the Core Knowledge skill objectives for this lesson. These objectives can be found in the Teacher Handbook and are derived directly from the Core Knowledge Sequence. They outline what students will be able to do as a result of the lesson.",
    :vocabulary_tier_2_words => "Please separate words with commas. Identify which of the shared domain/unit vocabulary will be used explicitly in this lesson, and extend the list to include additional terms such as general academic words/phrases or multiple meaning words. It is recommended that you limit this list to 3–5 words to focus and deepen vocabulary development.",
    :read_aloud_resources => "What read-aloud are you using in this lesson? Leave blank if you are not using a read-aloud.",
    :materials_and_resources => "List materials you need to complete this lesson.",
    :procedures => "In a list of numbered steps, describe the scope and sequence of the lesson. Remember to activate prior knowledge and/or review previously learned material at the beginning of your lesson, and include a summary component to close the lesson.",
    :extensions => "You may have crafted focusing and extending comprehension questions in the assessment section above; these questions should inform your extension activities.",
    :support_and_enrichment => "Describe how you will support students who are struggling and provide enrichment experiences for students who need a challenge.",
    :team_notes => "If you choose to share this lesson, these notes are displayed to all users at your school when viewing this lesson plan.",
    :personal_notes => "These notes are visible only to you."
  }

  HELP_BLOCKS = {
    :ongoing_assessment => "A means of determining what students know or can do with regard to the lesson objectives.  Informal, formative assessments provide you and your students with information about student progress and are typically not evaluated for a grade. Summative assessments provide information about student learning that frequently translates into a grade.",
    :criteria_for_success => 'The characteristics of a quality product or performance used to assess lesson objectives. (Note: CFS are often found on rubrics as the "top" of the scale.)',
    :read_aloud_resources => "Read-alouds are an effective means, in all grades, to introduce complex concepts and texts at or above your students’ reading ability. Read-alouds build conceptual understanding and comprehension while modeling tier 2 and 3 vocabulary in context.",
    :vocabulary_tier_2_words => "Tier 2 and Tier 3 words taught during this lesson. Tier 2 vocabulary includes words in the read-aloud which are not content-specific, but are terms that appear frequently in texts (fiction and/or nonfiction). Tier 3 vocabulary encompasses words that are essential to understanding the content of the lesson—they are domain-specific.",
    :procedures => "A set of step-by-step instructions for implementing your lesson. You may base your procedures on an instructional model (e.g., guided inquiry, direct instruction, concept attainment, etc.) and incorporate best practices such as framing the learning, activating prior knowledge, summarizing the learning, etc.",
    :extensions => "Activities that follow a read-aloud or a modeling lesson to engage students further with content and language (e.g., reading a different text on the content, exploring other related topics, or a hands‐on activity that extrapolates ideas and requires student use of the vocabulary). Core Knowledge Language Arts incorporates extensions during a different part of the instructional day to deepen learning after a read-aloud."
  }

  def placeholder_text_for(field)
    PLACEHOLDERS[field] || ""
  end

  def help_block_text_for(field)
    HELP_BLOCKS[field]
  end

  def enable_help_block_for(field)
    [ :ongoing_assessment, :criteria_for_success, :vocabulary_tier_2_words, 
      :procedures, :extensions, 
      :criteria_for_success, :assessment ].include? field
  end

  def measurable_objective_label_for(lesson_plan, guideline)
    text = "<strong>Measurable Objectives</strong>"
    siblings = lesson_plan.siblings_which_cover_guideline(guideline)
    return text if siblings.empty?
    text << "<p class='help-block'>This guideline covered in: "
    text << siblings.map(&:name).join(", ")
    text << "</p>"
  end

end
