# class QueryFieldPlaceholder
#   firstPlaceholderInterval: 3000
#   nextPlaceholderInterval: 6000
#   nextConstructionStepInterval: 40
#   placeholderChoices: I18n.t 'js.query_field.placeholder_words'
#   currentPlaceholder: ''
#   currentConstructionState: ''
#
#   constructor: ->
#     @queryField = $('#search_form_query')
#     if @queryField.length
#       _.delay @nextPlaceholder, @firstPlaceholderInterval, @
#
#   # start constructing next randomized placeholder
#   nextPlaceholder: (that) ->
#     # when field is in focus …
#     if that.queryField.is(':focus')
#       # … get a random placeholder …
#       placeholder = that.randomPlaceholder()
#       # … and put it character by character into the field
#       that.constructPlaceholder(
#         I18n.t 'js.query_field.example_placeholder', word: placeholder
#       )
#       that.currentPlaceholder = placeholder
#
#       # do it again in a few seconds
#       _.delay that.nextPlaceholder, that.nextPlaceholderInterval, that
#
#   # get a random element of the list (except the current one)
#   randomPlaceholder: ->
#     potentialWords = _.without @placeholderChoices, @currentPlaceholder
#     _.sample potentialWords
#
#   # construct placeholder words one character at a time
#   constructPlaceholder: (placeholder, that = @) ->
#     currentLength = that.currentConstructionState.length
#     totalLength = placeholder.length
#
#     if currentLength < totalLength
#       newConstructionState = placeholder.substr 0, (currentLength + 1)
#       that.queryField.attr 'placeholder', newConstructionState
#       that.currentConstructionState = newConstructionState
#
#       _.delay(
#         that.constructPlaceholder
#         that.nextConstructionStepInterval
#         placeholder, that
#       )
#     else
#       that.currentConstructionState = ''
#
# $(document).ready -> new QueryFieldPlaceholder
# # not on page:load or else we get overlapping timeouts
