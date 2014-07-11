class BooksWidget
  constructor: (widget) ->
    @_$widget = $ widget
    @_$author_select = $('.author select')
    @_$book_select = $('.book select')
    @_$message = $('.message')
    @_fetchData()

    @_$author_select.change =>
      $options = @_optionsFor @_currentAuthor().books, (book) -> book.title
      @_$book_select.empty().append $options

    @_$book_select.change =>
      @_$message.html("<b>#{@_currentAuthor().name}</b> написал произведение <b>#{@_currentBook.title}</b>")


  _fetchData: ->
    $.getJSON Routes.authors_path(), (data) =>
      @_authors = data
      $options = @_optionsFor @_authors, (author) -> author.name
      @_$author_select.empty().append $options

  _optionsFor: (array, callback) ->
    $options = $('<option>не выбрано</option>')
    for item in array
      $option = $ "<option value='#{item.id}'>#{callback(item)}</option>"
      $option.data(item)
      $options = $options.add $option
    $options

  _currentAuthor: ->
    @_$author_select.find(':selected').data()

  _currentBook: ->
    @_$book_select.find(':selected').data()

$ ->
  books_widget = new BooksWidget('.books_widget')