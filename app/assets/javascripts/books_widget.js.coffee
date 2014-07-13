getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1) + min);

class Select
  constructor: (@_$select) ->
    @setData []

  setData: (data, displayingField) ->
    @_$select.empty()
    $options = @_optionsFor data, displayingField
    @_$select.append $options

  selected: ->
    @_$select.find(':selected').data('object')

  selectRandom: ->
    options = @_$select.find('option')
    length = options.length
    index = getRandomInt(1, length-1)
    options.eq(index).prop('selected', true);

  # events

  change: (callback) ->
    @_$select.change callback

  # private

  # Converts array to options list
  _optionsFor: (array, displayingField) ->
    $options = $('<option value="0">не выбрано</option>')
    for item in array
      $option = $ "<option value='#{item.id}'>#{item[displayingField]}</option>"
      $option.data('object', item)
      $options = $options.add $option
    $options


class BooksWidget
  constructor: (@_$widget) ->
    @_author_select = new Select @_$widget.find('.author select')
    @_book_select = new Select @_$widget.find('.book select')
    @_$message = @_$widget.find('.message')
    @_fetchData()
    @_updateMessage()

    @_author_select.change =>
      @_updateBooksList()
      @_updateMessage()

    @_book_select.change =>
      @_updateMessage()

    $('button.lucky').click =>
      @_author_select.selectRandom()
      @_updateBooksList()
      @_book_select.selectRandom()
      @_updateMessage()

  # private

  # Saves data from server to @_authors array
  _fetchData: ->
    $.getJSON Routes.authors_path(), (data) =>
      @_authors = data
      @_author_select.setData data, 'name'

  # Setups options for books select
  _updateBooksList: ->
    @_book_select.setData @_currentAuthor()?.books ? [] , 'title'

  _updateMessage: ->
    author = @_currentAuthor()
    unless author?
      @_$message.html("выберите автора")
      return
    book = @_currentBook()
    unless book?
      @_$message.html("выберите произведение")
      return
    @_$message.html("<b>#{author.name}</b> написал произведение <b>#{book.title}</b>")

  _currentAuthor: ->
    @_author_select.selected()

  _currentBook: ->
    @_book_select.selected()


$ ->
  $widget = $('.books_widget')
  if $widget.length
    books_widget = new BooksWidget $widget