class SimphiInput
  HASH_ELEMENT_IDENTIFIER: '.hash-pair'

  constructor: (target) ->
    @target = $(target)
    @index = @target.siblings(@HASH_ELEMENT_IDENTIFIER).length + 1

  changedHashIndex: (original) ->
    original.replace(/hash-\d+/, "hash-#{@index}")

  newHashInput: ->
    instance = this
    sample = @target.siblings("#{@HASH_ELEMENT_IDENTIFIER}.sample").clone(true)
    sample.removeClass('sample')
    sample.attr('class': instance.changedHashIndex(sample.attr('class')))
    sample.find('input').each ->
      input = this
      $(input).removeAttr('disabled')
      $.each ['name', 'id'], ->
        currentValue = $(input).attr(this)
        $(input).attr(this, instance.changedHashIndex(currentValue))

    return sample

  addHashInput: ->
    newHashInput = this.newHashInput()
    $(newHashInput).insertBefore(@target)

  removeHashInput: ->
    @target.parents('.hash-pair').remove()

$(document).ready ->
  ####
  ## Add one more hash pair
  $('button.add_hash_pair').click (e) ->
    e.preventDefault()

    he = new SimphiInput e.currentTarget
    he.addHashInput()

  ####
  ## Remove hash pair
  $('button.remove_hash_pair').click (e) ->
    e.preventDefault()

    he = new SimphiInput e.currentTarget
    he.removeHashInput()
