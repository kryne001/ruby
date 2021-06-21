# require '~/Documents/Atom/Ruby/ruby/shelf.rb'
require_relative 'candy.rb'

list = Hash.new { |h, k| h[k] = [] }

list[:twix].push(Candy.new("twix"))
list[:twix].push(Candy.new("twix"))
list[:snickers].push(Candy.new("snickers"))

#=> {:foo=>[123, 456], :bar=>[789]}

puts list[:twix]


#=> 456

list
#=> {:foo=>[123], :bar=>[789]}
