# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

catalog = {
    'Александр Сергеевич Пушкин' => ['Капитанская дочка', 'Сказка о царе Салтане'],
    'Терри Пратчетт' => ['Цвет волшебства', 'Ночная стража', 'Последний герой', 'Опочтарение'],
    'Айзек Азимов' => ['Я, робот', 'Стальные пещеры', 'Роботы и Империя', 'Академия'],
    'Филип Пулман' => ['Северное сияние', 'Чудесный нож', 'Янтарный телескоп']
}

catalog.each do |author_name, books|
  author = Author.create name: author_name
  books.each do |book_title|
    author.books.create(title: book_title)
  end
end