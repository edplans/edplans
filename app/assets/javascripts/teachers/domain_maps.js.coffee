class DomainUnit extends Backbone.Model
  render: ->
    @view ||= new DomainUnitView({model: this})
    @view.render()

class DomainUnits extends Backbone.Collection
  model: DomainUnit

class DomainUnitView extends Backbone.View
  tagName: 'tr'
  template: JST['views/domain_unit']
  events:
    'click a.delete-domain-unit': 'destroy'
    'click a.edit-domain-unit': 'edit'
    'click a.clone-lesson-plan': 'clone'
    'click a.delete-lesson-plan': 'deleteLessonPlan'
  render: ->
    $(@el).html(@template(@model.attributes)).insertBefore $('tr.new-domain-unit')
    @model.lessonPlans.chain().
      sortBy((l) -> l.get('created_at')).
      each (lessonPlan) ->
        lessonPlan.render()
  destroy: (ev) =>
    ev.preventDefault()
    $.post("/domains/#{ DOMAIN_ID }/domain_units/#{ @model.id }", {'_method': 'delete'}, () =>
      $(@el).remove()
    , 'json')
  edit: (ev) ->
    ev.preventDefault()
    editView = new EditDomainUnitView({model: @model})
    editView.render()
  clone: (ev) ->
    ev.preventDefault()
    $(ev.target).parents('form.clone-lesson-plan').submit()
  deleteLessonPlan: (ev) ->
    ev.preventDefault()
    if confirm("Are you sure you want to delete this lesson plan? All associated files will also be deleted.")
      $(ev.target).parents('form.delete-lesson-plan').submit()

class NewDomainUnitView extends Backbone.View
  el: '#new-domain-unit'
  events:
    'submit form': 'submit'
  submit: (ev) ->
    ev.preventDefault()
    domain_units.create({
      name: $(ev.target).find('input#domain_unit_name').val()
      subject_id: $(ev.target).find('select#domain_unit_subject_id').val()
    }, {
      wait: true
      success: (domain_unit) -> domain_unit.render()
    })
    $(@el).modal('hide')

class EditDomainUnitView extends Backbone.View
  className: "modal hide fade"
  template: JST['views/edit_domain_unit']
  render: ->
    $(@el).html(@template(@model.attributes)).attr('id', "edit-domain-unit-#{ @model.id }").modal()
  events:
    'submit form': 'submit'
  submit: (ev) =>
    ev.preventDefault()
    @model.save({
      'name': @$('input#domain_unit_name').val()
      'subject_id': @$('select[name=domain_unit_subject_id]').val()
    }, {
      wait: true,
      success: (model) -> model.render()
    })

    $(@el).modal('hide')
    $(@el).remove()

class LessonPlan extends Backbone.Model
  toJSON: () ->
    { 'lesson_plan': { name: @get('name'), domain_unit_id: @get('domain_unit_id') } }
  render: () ->
    @view ||= new LessonPlanView({model: this})
    @view.render()

class LessonPlans extends Backbone.Collection
  model: LessonPlan

class LessonPlanView extends Backbone.View
  tagName: 'li'
  className: 'lesson-plan'
  template: JST['views/lesson_plan']
  container: () ->
    $("ul.lesson-plans[data-domain-unit-id=#{ @model.get('domain_unit_id') }]")
  render: ->
    $(@el).html(@template(@model.attributes)).attr('style', '').data('lesson-plan-id', @model.id)
    $(@el).draggable({revert: 'invalid'}) if @model.get('owned')
    $(@el).insertBefore @container().find('li.new-lesson-plan')

$ ->

  new NewDomainUnitView()

  window.domain_units = new DomainUnits()
  window.domain_units.url = "/domains/#{ window.DOMAIN_ID }/domain_units"
  window.domain_units.reset window.initial_domain_units
  window.domain_units.each (model) ->
    model.lessonPlans = new LessonPlans()
    model.lessonPlans.url = "/domains/#{ window.DOMAIN_ID }/domain_units/#{ model.id }/lesson_plans"
    model.lessonPlans.reset model.get('lesson_plans')
    model.render()

  $('td.domain-unit').droppable({
    accept: 'li.lesson-plan'
    drop: (event, ui) ->
      lessonPlan = window.domain_units.get($(ui.draggable).parents('td').data('domain-unit-id')).lessonPlans.get($(ui.draggable).data('lesson-plan-id'))
      lessonPlan.set('domain_unit_id', $(this).data('domain-unit-id'))
      lessonPlan.save()
      lessonPlan.render()
  })
