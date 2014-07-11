getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1) + min);


class BooksWidget
  constructor: (widget) ->
    @_$widget = $ widget
    @_$author_select = $('.author select')
    @_$book_select = $('.book select')
    @_$message = $('.message')
    @_fetchData()
    @_setMessage()

    @_$author_select.change =>
      @_setBooksList()
      @_setMessage()

    @_$book_select.change =>
      @_setMessage()

    $('button.lucky').click =>
      @_selectRandomOption @_$author_select.find('option')
      @_setBooksList()
      @_selectRandomOption @_$book_select.find('option')
      @_setMessage()

  _fetchData: ->
    $.getJSON Routes.authors_path(), (data) =>
      @_authors = data
      $options = @_optionsFor @_authors, (author) -> author.name
      @_$author_select.empty().append $options

  _optionsFor: (array, callback) ->
    $options = $('<option value="0">не выбрано</option>')
    for item in array
      $option = $ "<option value='#{item.id}'>#{callback(item)}</option>"
      $option.data('object', item)
      $options = $options.add $option
    $options

  _setBooksList: ->
    @_$book_select.empty()
    try
      $options = @_optionsFor @_currentAuthor().books, (book) -> book.title
      @_$book_select.append $options

  _currentAuthor: ->
    @_$author_select.find(':selected').data('object')

  _currentBook: ->
    @_$book_select.find(':selected').data('object')

  _setMessage: ->
    author = @_currentAuthor()
    unless author?
      @_$message.html("выберите автора")
      return
    book = @_currentBook()
    unless book?
      @_$message.html("выберите произведение")
      return
    @_$message.html("<b>#{author.name}</b> написал произведение <b>#{book.title}</b>")

  _selectRandomOption: (options) ->
    length = options.length
    index = getRandomInt(1, length-1)
    options.eq(index).prop('selected', true);

$ ->
  books_widget = new BooksWidget('.books_widget')