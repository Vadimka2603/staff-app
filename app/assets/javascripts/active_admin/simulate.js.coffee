jQuery(document).ready ($) ->
  $('.button.has_many_add').hide()
  $('#simulate').on 'click', ->
    $('.button.has_many_remove').click()
    female_count = $('#female_count')[0].valueAsNumber
    male_count = $('#male_count')[0].valueAsNumber
    count = male_count + female_count
    $('.button.has_many_add').click() for [1..count]
    $('.button.has_many_remove').hide()

