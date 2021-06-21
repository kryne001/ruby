require_relative 'candy.rb'
require_relative 'shelf.rb'

class Shop
   attr_accessor :shelves, :unshelved_hash, :unshelved_names

   def initialize
      @shelves = []
      @unshelved_hash = Hash.new{ |h, k| h[k] = []}
      @unshelved_names = []
   end

   def check_if_exists(candy)
      @unshelved_names.each {|str| return 1 if str == candy.name}
      return 0
   end

   def push_new_unshelved(candy)
      @unshelved_names << candy.name
      @unshelved_hash[@unshelved_names.last].push(candy)
   end

   def push_existing_unshelved(candy)
      @unshelved_names.each{|x| @unshelved_hash[x].push(candy) && break if x == candy.name}
   end

   def receive_candy(candy)
      check = self.check_if_exists(candy)
      if check == 0
         self.push_new_unshelved(candy)
      else
         self.push_existing_unshelved(candy)
      end
   end

   def receive_group(list)
      list.each{|x| self.receive_candy(x)}
   end

   def get_hash_key(candy_name)
      @unshelved_names.each{|x| return x if candy_name == x}
   end

   def find_empty_shelf
      @shelves.each {|str| return @shelves.index(str) if str.shelf_full == 0}
      @shelves << Shelf.new
      return @shelves.index(@shelves.last)
   end

   def get_unshelved_candy(candy_name)
      @unshelved_names.each {|x| return @unshelved_hash[self.get_hash_key(candy_name)].pop() if candy_name == x}
      return -1
   end

   def shelve_single(candy_name)
      candy = self.get_unshelved_candy(candy_name)
      if candy == -1
         puts "candy doesn't exist"
      else
         @shelves[self.find_empty_shelf].add_candy(candy)
      end
   end

   def shelve_group(candy_name)
      i = @unshelved_hash[self.get_hash_key(candy_name)].length
      until i == 0
         self.shelve_single(candy_name)
         i-=1
      end
   end

   def shelve_all
      @unshelved_names.each {|x| self.shelve_group(x)}
   end

   def print_unshelved
      puts "Unshelved candies: "
      @unshelved_names.each do |x|
            print x
            print ": "
            puts @unshelved_hash[x].length.to_s
      end
   end

   def print_shelved
      @shelves.each do |x|
         print "Shelf "
         print (@shelves.index(x)+1).to_s
         puts ": "
         x.print_shelf
      end
   end
   def print_shop
      self.print_unshelved
      self.print_shelved
   end

end

shop1 = Shop.new
shop1.receive_candy(Candy.new("twix"))
shop1.receive_candy(Candy.new("twix"))
shop1.receive_candy(Candy.new("snickers"))
shop1.shelve_single("snickers")
shop1.shelve_single("twix")
shop1.shelve_all

list = [Candy.new("mars"),Candy.new("mars"),Candy.new("mars")]
shop1.receive_group(list)
shop1.shelve_group("mars")

list = [Candy.new("food"),Candy.new("food"),Candy.new("food")]
shop1.receive_group(list)
shop1.shelve_group("food")


shop1.print_shop
