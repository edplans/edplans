class KnowledgeConnection extends Backbone.Model
  render: () ->
    @view ||= new KnowledgeConnectionView({model: this})
    @view.render()

class KnowledgeConnections extends Backbone.Collection
  model: KnowledgeConnection

class KnowledgeConnectionView extends Backbone.View
  className: 'knowledge-connection'
  tagName: 'li'
  template: JST["views/knowledge_connection"]
  parentContainer: () ->
    if @model.get('prior_knowledge_id')?
      $('td#prior-knowledge ul')
    else if @model.get('future_knowledge_id')?
      $('td#future-knowledge ul')
    else
      $('td#cross-curricular ul')
  events:
    'click a.toggle-cross-curricular-link': 'toggle'
  toggle: (ev) ->
    ev.preventDefault()
    $.post $(ev.target).attr('href'),
      {'_method': 'PUT'},
      $(@el).toggleClass('omitted'),
      'json'
  render: () ->
    unless @parentContainer().children("li:contains('#{ @model.get('name') }')")[0]?
      $(@el).html(@template(@model.attributes))
      $(@el).attr 'data-sortKey', "#{ @model.get('grade') }#{ @model.get('name') }"
      $(@el).addClass('omitted') if @model.id in window.omitted_cross_curricular_links
      @parentContainer().append @el

class MappedGuideline extends Backbone.Model
  initialize: ->
    @retrieveKnowledgeConnections()
  addStandards: ->
    for index, standardId of @get('standard_ids')
      unless mappedStandards.get(standardId)?
        mappedStandards.add allStandards.get(standardId)
  retrieveKnowledgeConnections: ->
    @knowledgeConnections ||= new KnowledgeConnections()
    @knowledgeConnections.url = "/guidelines/#{ @get('guideline_id') }/knowledge_connections"
    @knowledgeConnections.fetch
      success: () => @renderKnowledgeConnections()
  renderKnowledgeConnections: ->
    @knowledgeConnections.each (kc) -> kc.render()
    for list of $('ul.knowledge-connections')
      $(list).children('li').sortElements (a, b) ->
        $(a).data('sortKey') > $(b).data('sortKey')
  removeKnowledgeConnections: ->
    for index, standardId of @get('standard_ids')
      mappedStandards.remove(standardId)
    @knowledgeConnections.each (kc) -> kc.view.remove()
  url: ->
    "/my_school/domain_maps/#{ @get('domain_id') }/school_years/#{ window.schoolYearId }/guidelines/#{ @get('guideline_id') }"
  render: ->
    @view ||= new MappedGuidelineView(
      model: this
      container: $('td#content-target ul')
    )
    @view.render()

class MappedGuidelines extends Backbone.Collection
  model: MappedGuideline

class MappedSkillsGuideline extends Backbone.Model
  addStandards: ->
    for index, standardId of @get('standard_ids')
      unless mappedSkillsStandards.get(standardId)?
        mappedSkillsStandards.add allSkillsStandards.get(standardId)
  url: ->
    "/my_school/domain_maps/#{ @get('domain_id') }/school_years/#{ window.schoolYearId }/skills_guidelines/#{ @get('guideline_id') }"
  render: ->
    @view ||= new MappedGuidelineView(
      model: this
      container: $('td#skills-content-target ul')
    )
    @view.render()

class MappedSkillsGuidelines extends Backbone.Collection
  model: MappedSkillsGuideline

class MappedGuidelineView extends Backbone.View
  tagName: 'li'
  className: 'mapped-guideline'
  template: JST["views/mapped_guideline"]
  initialize: (options) ->
    @model = options.model
    @container = options.container
  render: ->
    $(@el).html(@template(@model.attributes))
    if (@model.get('custom'))
      $(@el).addClass('custom')
    @container.append(@el)
  events:
    'click a.unmap-guideline': 'unmap'
    'mouseenter': 'showUnmap'
    'mouseleave': 'showUnmap'
  showUnmap: ->
    $(@el).find('a.unmap-guideline').toggle()
  unmap: (ev) ->
    ev.preventDefault()
    $("span.guideline.mapped[data-guideline-id=#{ @model.get('guideline_id') }]").removeClass('mapped').draggable(
      helper: () =>
        "<span class='guideline'><i class='icon-bookmark' />#{ @model.get('draggable_text') }</span>"
    )
    @model.destroy({wait: true})
    $(@el).remove()

class Standard extends Backbone.Model
  render: ->
    @view ||= new StandardView(
      model: this
      container: $('td#state-standards-target ul.state-standards')
    )
    @view.render()
  grayOut: ->
    $("li.standard[data-standard-id=#{ @id }]").addClass "mapped"
  restore: ->
    $("li.standard[data-standard-id=#{ @id }]").removeClass("mapped").draggable { helper: 'clone' }


class SkillsStandard extends Backbone.Model
  render: ->
    @view ||= new StandardView(
      model: this
      container: $('td#skills-state-standards-target ul.state-standards')
    )
    @view.render()
  grayOut: ->
    $("li.standard[data-standard-id=#{ @id }]").addClass "mapped"
  restore: ->
    $("li.standard[data-standard-id=#{ @id }]").removeClass("mapped").draggable { helper: 'clone' }

class CCSSStandards extends Backbone.Collection
  model: Standard
  addToDomainMap: (standard) ->
    $.post "#{ @url }/#{ standard.id }", {'_method': 'PUT'}
  removeFromDomainMap: (standard) ->
    $.post "#{ @url }/#{ standard.id }", {'_method': 'DELETE'}

class CCSSSkillsStandards extends Backbone.Collection
  model: SkillsStandard
  addToDomainMap: (standard) ->
    $.post "#{ @url }/#{ standard.id }", {'_method': 'PUT'}
  removeFromDomainMap: (standard) ->
    $.post "#{ @url }/#{ standard.id }", {'_method': 'DELETE'}

class StandardView extends Backbone.View
  tagName: 'li'
  className: 'mapped-standard'
  template: JST["views/mapped_standard"]
  initialize: (options) ->
    @model = options.model
    @container = options.container
  events:
    'mouseenter': 'showOmit'
    'mouseleave': 'showOmit'
    'click a.omit-standard': 'removeStandard' #'toggleOmission'
  render: ->
    $(@el).html(@template(@model.attributes)).find('a[rel=popover]').mouseenter(
      () -> $(this).popover('show')
    ).mouseleave(
      () -> $(this).popover('hide')
    )
    @container.append(@el)
  showOmit: ->
    $(@el).find('a.omit-standard').toggle()
  removeStandard: (ev) ->
    ev.preventDefault()
    @model.collection.removeFromDomainMap(@model)
    @model.collection.remove(@model)

class VocabularyListView extends Backbone.View
  el: 'td#domain-vocabulary'
  wordTemplate: (word) ->
    "<li>#{ word } <a href='/my_school/domain_maps/#{ window.domain_id }/school_years/#{ window.schoolYearId }/vocabulary/#{ word }' class='remove-word hide'>&times;</a></li>"
  events:
    'click input.submit-word': 'add'
    'click a.remove-word': 'remove'
    'mouseenter li': 'toggleRemove'
    'mouseleave li': 'toggleRemove'
  add: (ev) ->
    ev.preventDefault()
    newWord = @$('#new-word').val()
    $.ajax { url: @$('form.add-word').attr('action'), type: 'PUT', data: { word: newWord } }
    @$('ul.domain-vocabulary:last').append(@wordTemplate(newWord))
    @$('#new-word').val('').focus()
  remove: (ev) ->
    ev.preventDefault()
    target = $(ev.target)
    $.ajax { url: target.attr('href'), type: 'DELETE' }
    target.parent('li').remove()
  toggleRemove: (ev) ->
    $(ev.target).find('a.remove-word').toggle()

$ ->

  window.allStandards = new CCSSStandards()
  window.allSkillsStandards = new CCSSSkillsStandards()
  allStandards.reset window.all_standards
  allSkillsStandards.reset window.all_standards

  window.mappedStandards = new CCSSStandards()
  mappedStandards.url = "/my_school/domain_maps/#{ window.domain_id }/school_years/#{ window.schoolYearId }/included_standards"
  mappedStandards.reset window.initial_mapped_standards
  mappedStandards.each (standard) ->
    standard.grayOut()
    standard.render()
  mappedStandards.on 'add', (standard) ->
    standard.collection = mappedStandards
    standard.grayOut()
    standard.render()
  mappedStandards.on 'remove', (standard) ->
    standard.restore()
    standard.view.remove()

  window.mappedSkillsStandards = new CCSSSkillsStandards()
  mappedSkillsStandards.url = "/my_school/domain_maps/#{ window.domain_id }/school_years/#{ window.schoolYearId }/included_skills_standards"
  mappedSkillsStandards.reset window.initial_mapped_skills_standards
  mappedSkillsStandards.each (standard) ->
    standard.grayOut()
    standard.render()
  mappedSkillsStandards.on 'add', (standard) ->
    standard.collection = mappedSkillsStandards
    standard.grayOut()
    standard.render()
  mappedSkillsStandards.on 'remove', (standard) ->
    standard.restore()
    standard.view.remove()

  window.mappedGuidelines = new MappedGuidelines()
  mappedGuidelines.reset window.initial_mapped_guidelines
  mappedGuidelines.each (mg) ->
    mg.render()
  mappedGuidelines.on 'remove', (guideline) ->
    guideline.removeKnowledgeConnections()
    mappedGuidelines.each (guideline) ->
      guideline.renderKnowledgeConnections()
    mappedStandards.each (model) ->
      model.view.remove()
    mappedStandards.fetch
      success: (collection) ->
        collection.each (model) ->
          model.render()
      reset: true
      
  window.mappedSkillsGuidelines = new MappedSkillsGuidelines()
  mappedSkillsGuidelines.reset window.initial_mapped_skills_guidelines
  mappedSkillsGuidelines.each (mg) ->
    mg.render()
  mappedSkillsGuidelines.on 'remove', (guideline) ->
    mappedSkillsStandards.each (standard) ->
      standard.view.remove()
    mappedSkillsStandards.fetch
      success: (collection) ->
        collection.each (model) ->
          model.render()
      reset: true

  window.vocabularyListView = new VocabularyListView()

  $('.applicable').parentsUntil('ul.curriculum').addClass('applicable-child');

  $('span.guideline:not(.mapped)').draggable(
    helper: () ->
      "<span class='guideline'><i class='icon-bookmark' />#{ $(this).data('draggable-text') }</span>"
  )

  $('ul.tree-browser li a:not(.delete-custom-guideline, .new-custom-guideline)').click (ev) ->
    ev.preventDefault()
    icon = $(this).siblings('i')
    if icon.hasClass('icon-folder-close')
      icon.removeClass('icon-folder-close').addClass('icon-folder-open')
    else
      icon.removeClass('icon-folder-open').addClass('icon-folder-close')
    $(this).siblings('ul').children('li:not(.applied)').toggle()

  $('td#content-target').droppable(
    accept: 'span.guideline'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      mappedGuidelines.create({
        guideline_id: $(ui.draggable).data('guideline-id')
        domain_id: window.domain_id
        standard_ids: $(ui.draggable).data('standards')
      }, {
        wait: true
        success: (mappedGuideline) ->
          $(ui.draggable).addClass('mapped')
          mappedGuideline.addStandards()
          mappedGuideline.render()
      })
  )

  $('li.standard:not(.mapped)').draggable(
    helper: "clone"
  )
  
  $('td#state-standards-target').droppable(
    accept: 'li.standard'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      standard = allStandards.get $(ui.draggable).data('standard-id')
      mappedStandards.addToDomainMap(standard)
      mappedStandards.add(standard)
  )

  $('td#skills-state-standards-target').droppable(
    accept: 'li.standard'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      standard = allSkillsStandards.get $(ui.draggable).data('standard-id')
      mappedSkillsStandards.addToDomainMap(standard)
      mappedSkillsStandards.add(standard)
  )

  $('td#skills-content-target').droppable(
    accept: 'li.ela span.guideline'
    hoverClass: 'ui-state-highlight'
    drop: (event, ui) ->
      mappedSkillsGuidelines.create({
        guideline_id: $(ui.draggable).data('guideline-id')
        domain_id: window.domain_id
        standard_ids: $(ui.draggable).data('standards')
      }, {
        wait: true
        success: (mappedGuideline) ->
          $(ui.draggable).addClass('mapped')
          mappedGuideline.addStandards()
          mappedGuideline.render()
      })
  )

  $('form.edit_scheduled_domain').submit (ev) ->
    ev.preventDefault()
    input = $(this).find('input#scheduled_domain_days')
    days = input.val()
    $.post $(this).attr('action'), {
      _method: 'PUT'
      scheduled_domain: {
        days: days
      }
    }, ->
      input.effect('highlight')
    , 'json'
