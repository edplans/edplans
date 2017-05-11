class Guideline extends Backbone.Model
  urlRoot: '/my_school/guidelines'
  abbreviatedText: ->
    if @get('name').length > 30
      "#{ @get('name')[0..27] }..."
    else
      @get('name')
  render: ->
    @view ||= new CustomGuidelineView({model: this})
    @view.render()

class CustomGuidelineView extends Backbone.View
  tagName: 'li'
  template: JST['views/custom_guideline']
  insertBefore: ->
    $("li[data-curriculum-node-id=#{ @model.get('curriculum_node_id') }] > ul.guidelines li.new-custom-guideline")
  events:
    'click a.delete-custom-guideline': 'remove'
  render: ->
    abbreviatedText = @model.abbreviatedText()
    $(@el).
      insertBefore(@insertBefore()).
      html(@template(@model.attributes)).
      find('span.guideline').
      draggable(
        helper: () ->
          "<span class='guideline'><i class='icon-bookmark' />#{ abbreviatedText }</span>"
      )
  remove: (ev) ->
    ev.preventDefault()
    $.post "/my_school/guidelines/#{ @model.id }", { "_method": "delete" }
    $(@el).remove()
    
  
class NewGuidelineView extends Backbone.View
  el: '#new-custom-guideline'
  setCurriculumNode: (nodeId) ->
    @$('#guideline_curriculum_node_id').val nodeId
  events:
    'click input.btn-primary': 'submit'
  submit: (ev) ->
    ev.preventDefault()
    guideline = new Guideline()
    guideline.save({
      curriculum_node_id: $('#guideline_curriculum_node_id').val()
      name: $('#guideline_name').val()
      notes: $('#guideline_notes').val()
    }, {
      wait: true
      success: (model) ->
        model.render()
    })
    @$('#guideline_name').val('')
    @$('#guideline_notes').data('wysihtml5').editor.clear()
    $('#new-custom-guideline').modal('hide')

$ ->

  if $('#new-custom-guideline').length > 0
    window.newGuidelineView = new NewGuidelineView()
    
  $('a.new-custom-guideline').click (ev) ->
    newGuidelineView.setCurriculumNode($(this).data('curriculumNodeId'))