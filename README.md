# JsonModel

Simple persist your model data to a .json file

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_model

## Usage

book.rb

    require 'json_model'

    class Book
      include JsonModel

      field :name
      field :author
    end

    # create some books
    Book.new({name: 'Inferno', author: 'Dan Brown'}).save
    Book.new({name: 'Das verlorene Symbol', author: 'Dan Brown'}).save
    Book.new({name: 'Diabolus', author: 'Dan Brown'}).save

    # list all books
    puts "\n--- List all books"
    Book.all.map{|book| puts "#{book.id} - #{book.name} by #{book.author}" }

    # find a book by id
    puts "\n--- Find book with id=1"
    book = Book.find(1)
    puts "Book: #{book.to_json}"

    # update a book
    puts "\n--- Update name of book with id=1"
    book = Book.find(1)
    book.name = 'Illuminati'
    book.save
    Book.all.map{|book| puts "#{book.id} - #{book.name} by #{book.author}" }

    # find a book by name
    puts "\n--- Find book by name 'Illuminati'"
    book = Book.find_by(name: 'Illuminati')
    puts "Book: #{book.to_json}"

    # delete a book
    puts "\n--- Delete book with Id=2"
    book = Book.find(2)
    book.destroy
    Book.all.map{|book| puts "#{book.id} - #{book.name} by #{book.author}" }


## Contributing

1. Fork it ( https://github.com/[my-github-username]/json_model/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
