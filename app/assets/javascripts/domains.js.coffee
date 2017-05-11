class Domain extends Backbone.Model
  toggleInclusion: ->
    @set('included', !(@get('included')))
    @render()
    @save()
  render: ->
    @view ||= new DomainView({model: this})
    @view.render()

class Domains extends Backbone.Collection
  model: Domain
  url: "/my_school/domains"

class DomainView extends Backbone.View
  tagName: 'tr'
  className: "domain"
  template: JST['views/domain']
  events:
    'click a.toggle-domain': 'toggleInclusion'
    'click a.delete-domain': 'destroy'
    'click input.update-domain': 'update'
  toggleInclusion: ->
    @model.toggleInclusion()
  headerRow: ->
    if $("tr.grade-header.grade-#{ @model.get('grade') }.tag-#{ @model.get('tag_class_name') }").length > 0
      $("tr.grade-header.grade-#{ @model.get('grade') }.tag-#{ @model.get('tag_class_name') }")
    else
      $(@headerRowTemplate(@model.attributes)).insertBefore("tr.custom-domain.grade-#{ @model.get('grade') }")
  headerRowTemplate: JST['views/domain_header_row']
  removeHeaderIfEmpty: ->
    if $("tr.grade-#{ @model.get('grade') }.tag-#{ @model.get('tag_class_name') }").length < 3
      @headerRow().remove()
  destroy: (ev) ->
    ev.preventDefault()
    if confirm("Are you sure you want to delete the #{ @model.get('name') } domain?")
      scheduled_domains.removeByName(@model.get('name'))
      @removeHeaderIfEmpty()
      @model.destroy()
      $(@el).remove()
  update: (ev) ->
    ev.preventDefault()
    @model.set 'name', @$("input[name='domain[name]']").val()
    @model.save()
    $("#edit-domain-#{ @model.id }").modal 'hide'
    @render()
    window.loadScheduledDomainData(@model.get('grade'))
  render: ->
    $(@el).html(@template(@model.attributes)).addClass("grade-#{ @model.get('grade') }").addClass("tag-#{ @model.get('tag_class_name') }")
    @$('span.domain').draggable {
      helper: () =>
        "<div class='scheduled-domain' style='z-index:9;'>#{ @model.get('name') }</div>"
    }
    if $(@el).parents('table').length == 0
      $(@el).insertBefore @headerRow().nextUntil('tr.grade-header').last()
      $(@el).show()

class NewDomainView extends Backbone.View
  events:
    'click input.btn-primary': 'submit'
  submit: (ev) ->
    ev.preventDefault()
    domain = domains.create({
      name: @$('#domain_name').val()
      grade: @$('#domain_grade').val()
      days: @$('#domain_days').val()
      tag: @tag()
    }, {
      wait: true
      success: (domain) ->
        domain.render()
    })
    # When adding with a new subject
    unless @$("select#domain_tag option[value='#{ domain.get('tag') }']")[0]
      @$("select#domain_tag").append("<option value='#{ domain.get('tag') }'>#{ domain.get('tag') }</option>")
    @$('.close').trigger 'click'
    @$('#domain_name, #domain_days, #domain_tag').val('')

class NewInterdisciplinaryDomainView extends NewDomainView
  el: '#new-interdisciplinary-domain'
  tag: () -> "Interdisciplinary"

class NewCourseUnitView extends NewDomainView
  el: '#new-course-unit'
  tag: () ->
    if @$('input#domain_tag').val().length == 0
      @$('select#domain_tag').val()
    else
      @$('input#domain_tag').val()


window.domains = new Domains()

$ ->
  if $('#newCustomDomain').length > 0
    new NewInterdisciplinaryDomainView()
    new NewCourseUnitView()

  $('.continue-new-domain').click (ev) ->
    ev.preventDefault()
    $('#newCustomDomain').modal 'hide'
    $($(this).attr('href')).modal 'show'