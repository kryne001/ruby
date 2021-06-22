require_relative 'candy.rb'
require_relative 'shelf.rb'

class Shop
   attr_accessor :shelves, :unshelved_hash, :unshelved_names

   def initialize # initializer
      @shelves = [] # array that holds type Shelf for all shelfs in shop
      @unshelved_hash = Hash.new{ |h, k| h[k] = []} # 2D hash array that holds all unshelved candies in shop
   end

   def receive_candy(candy)
      # adds new candy type into unshelved list
      @unshelved_hash[candy.name].push(candy)
   end

   def receive_group(list)
      # called if user wants to add an entire bulk shipment of candy
      list.each{|x| self.receive_candy(x)}
   end

   def get_hash_key(candy_name)
      # returns name of candy if it exists in unshelved list
      @unshelved_hash.keys.each{|x| return x if candy_name == x}
   end

   def find_candy_in_shelves(candy_name)
      # booleans
      # returns true if candy type has been placed on a shelf
      @shelves.each {|x| return @shelves.index(x) if x.find_candy(candy_name) == 1}
      return -1
   end

   def find_open_shelf
      # finds shelf that still has room for candy type
      # only called if new candy to be shelved does not exist on other shelves
      # first, parses through existing shelves in shop to find an empty shelf
      # returns index of shelf in @shelves array if shelf contains candy type
      # if not found, creates new shelf, pushes onto @shelves array, and returns index of new shelf in @shelves array
      @shelves.each {|str| return @shelves.index(str) if str.check_full == 0}
      @shelves << Shelf.new
      return @shelves.index(@shelves.last)
   end

   def get_unshelved_candy(candy_name)
      return @unshelved_hash[candy_name].pop()
   end

   def shelve_single(candy_name)
      # adds single candy to shelf
      # takes in desired candy to shelve as argument
      # first, gets desired candy from unshelved list (method ends if candy doesnt exist)
      # next, check if desired candy type has already been placed on a shelf
      # if yes, adds candy to shelf
      # if no, finds a shelf thats open (or create new shelf) and adds candy there
      shelf = self.find_open_shelf
      @shelves[shelf].add_candy(self.get_unshelved_candy(candy_name))
      if @unshelved_hash[candy_name].length == 0
         @unshelved_hash.delete(candy_name)
      end
   end

   def shelve_group(candy_name)
      # shelves entire collection of unshelved candy type
      i = @unshelved_hash[self.get_hash_key(candy_name)].length
      until i == 0
         self.shelve_single(candy_name)
         i-=1
      end
   end

   def shelve_all
      # shelves all candies in unshelved list
      @unshelved_hash.keys.each {|x| self.shelve_group(x)}
   end

   def remove_candy(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      self.receive_candy(@shelves[shelf].remove_candy(candy_name))
   end

   # def remove_group(candy_name)
   #    shelf = self.find_candy_in_shelves(candy_name)
   # end

   def print_unshelved
      # prints unshelved list
      if @unshelved_hash.keys.length == 0
         puts "No unshelved candies"
      else
         puts "Unshelved candies: "
         @unshelved_hash.keys.each do |x|
               print x
               print ": "
               puts @unshelved_hash[x].length.to_s
         end
      end
   end

   def print_shelved
      # prints all shelves in shop's contents
      @shelves.each do |x|
         print "Shelf "
         print (@shelves.index(x)+1).to_s
         puts ": "
         x.print_shelf
      end
   end

   def print_shop
      # prints both unshelved list and all shelves in shop's contents
      self.print_unshelved
      self.print_shelved
   end

end

shop1 = Shop.new
shop1.receive_candy(Candy.new("twix"))
shop1.print_shop
shop1.receive_candy(Candy.new("twix"))
shop1.print_shop
shop1.receive_candy(Candy.new("snickers"))
shop1.print_shop
shop1.shelve_single("snickers")
shop1.print_shop
shop1.shelve_single("twix")
shop1.print_shop
shop1.shelve_all
shop1.print_shop

#
# list = [Candy.new("mars"),Candy.new("mars"),Candy.new("mars")]
# shop1.receive_group(list)
# shop1.shelve_group("mars")
#
# list = [Candy.new("food"),Candy.new("food"),Candy.new("food")]
# shop1.receive_group(list)
# shop1.shelve_group("food")
#
# list = [Candy.new("mars"),Candy.new("mars"),Candy.new("mars")]
# shop1.receive_group(list)
# shop1.shelve_group("mars")

# shop1.remove_candy("food")

# shop1.print_shop
