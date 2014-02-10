class window.FormSeriesBase extends Backbone.View
  events:
    'click .display': 'showEdit'
    'click .save'   : 'save'
    'click .add'    : 'addPosition'
    'click .remove' : 'removeAnswer'

  field_name: 'concept_position'

  initialize: () ->
    for val in @loadValues()
      @$('.edit .positions').append @positionTemplate(val)

    @$('.display').html @$('.hidden input').val()

  loadValues: ->
    vals = JSON.parse(@$('.hidden input').val())
    if _.isEmpty(vals) then vals = [" "]
    vals

  showEdit: ->
    @$('.display').hide()
    @$('.edit')   .show()

  save: ->
    @$('.display').show()
    @$('.edit')   .hide()
    @$('.hidden input').val @conceptOrderString()
    @$('.display').html     @conceptOrderString()

  addPosition: ->
    @$('.edit .positions').append @positionTemplate()

  positionTemplate: (val="") ->
    val = val.trim()

    $("""
      <div class="field string concept-position control-group">
        <div class="controls">
          <textarea id="chapter_concept_position" name="#{@field_name}[]" size="30" type="text" value=""></textarea>
          <a href="#remove" class="remove">Remove</a>
        </div>
      </div>
    """).find('textarea').val(val).end()

  conceptOrderString: ->
    JSON.stringify(this.asJSON())

  asJSON: ->
    _.map(@$('.concept-position textarea'), (el) -> $(el).val())

  removeAnswer: (e) ->
    $(e.target).closest('.concept-position').remove()

class window.ConceptReviewRoot extends FormSeriesBase
  positionTemplate: (val="") ->
    if typeof val == 'string'
      val = [val, '']
    $("""
      <div class="field string concept-position control-group">
        <div class="controls">
          <input type="text" name="rule_id[]"        value="#{val[0]}" style="width: 40px" class="rule-id">
          <input type="text" name="question_count[]" value="#{val[1]}" style="width: 40px" class="question-count">
          <a href="#remove" class="remove">Remove</a>
        </div>
      </div>
    """).find('textarea').val(val).end()

  asJSON: ->
    _.map @$('.concept-position'), (el) ->
      ruleId        = $(el).find('.rule-id').val()
      questionCount = $(el).find('.question-count').val()
      [ruleId, questionCount]

  loadValues: ->
    vals = JSON.parse(@$('.hidden input').val())
    if _.isEmpty(vals) then vals = [" "]
    vals


class window.LessonAnswerRoot extends FormSeriesBase
  initialize: ->
    alert 'ok'
    super JSON.parse(@$('.hidden input').val())
    _.bindAll 'save'

    @$el.closest('form').find('.form-actions .btn').on 'click', =>
      @save()
      @$('textarea[name="lesson[answer_array_json]"]').remove()

  field_name: 'answer_options'

dataLoad = (cla) ->
  new window[cla] {el} for el in $("""*[data-view="#{cla}"]""")

loadSeriesRoots = ->
  dataLoad 'ConceptReviewRoot'
  dataLoad 'LessonAnswerRoot'
  dataLoad 'RuleExamplesRoot'

jQuery(document).on 'page:load', loadSeriesRoots
jQuery loadSeriesRoots
