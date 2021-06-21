require_relative 'candy.rb'
require_relative 'shelf.rb'

class Shop
   attr_accessor :shelves, :unshelved_hash, :unshelved_names

   def initialize # initializer
      @shelves = [] # array that holds type Shelf for all shelfs in shop
      @unshelved_hash = Hash.new{ |h, k| h[k] = []} # 2D hash array that holds all unshelved candies in shop
      @unshelved_names = [] # array of strings that holds name of all unshelved candies in shop
   end

   def check_if_exists_unshelved(candy)
      # boolean
      # checks if candy is in unshelved list
      # returns 1 if found, 0 if not
      @unshelved_names.each {|str| return 1 if str == candy.name}
      return 0
   end

   def push_new_unshelved(candy)
      # adds new candy type into unshelved list
      @unshelved_names << candy.name
      @unshelved_hash[@unshelved_names.last].push(candy)
   end

   def push_existing_unshelved(candy)
      # adds existing candy type to unshelved list
      @unshelved_names.each{|x| @unshelved_hash[x].push(candy) && break if x == candy.name}
   end

   def receive_candy(candy)
      # receives new single candy to shop and adds to unshelved list
      # all new candy into shop is added to unshelved list first before being shelved
      # first, checks if new candy type is already in unshelved list
      # if no, push new candy type into unshelved list
      # if yes, push existing candy type into unshelved list
      check = self.check_if_exists_unshelved(candy)
      if check == 0
         self.push_new_unshelved(candy)
      else
         self.push_existing_unshelved(candy)
      end
   end

   def receive_group(list)
      # called if user wants to add an entire bulk shipment of candy
      list.each{|x| self.receive_candy(x)}
   end

   def get_hash_key(candy_name)
      # returns name of candy if it exists in unshelved list
      @unshelved_names.each{|x| return x if candy_name == x}
   end

   def find_candy_in_shelves(candy_name)
      # booleans
      # returns true if candy type has been placed on a shelf
      @shelves.each {|x| return @shelves.index(x) if x.check_if_exists(candy_name) == 1}
      return -1
   end

   def find_open_shelf
      # finds shelf that still has room for candy type
      # only called if new candy to be shelved does not exist on other shelves
      # first, parses through existing shelves in shop to find an empty shelf
      # returns index of shelf in @shelves array if shelf contains candy type
      # if not found, creates new shelf, pushes onto @shelves array, and returns index of new shelf in @shelves array
      @shelves.each {|str| return @shelves.index(str) if str.shelf_full == 0}
      @shelves << Shelf.new
      return @shelves.index(@shelves.last)
   end

   def get_unshelved_candy(candy_name)
      # returns desired candy from unshelved list
      # pops candy from unshelved list
      # return -1 if candy type passed in does not exist to signify fail
      @unshelved_names.each {|x| return @unshelved_hash[self.get_hash_key(candy_name)].pop() if candy_name == x}
      return -1
   end

   def shelve_single(candy_name)
      # adds single candy to shelf
      # takes in desired candy to shelve as argument
      # first, gets desired candy from unshelved list (method ends if candy doesnt exist)
      # next, check if desired candy type has already been placed on a shelf
      # if yes, adds candy to shelf
      # if no, finds a shelf thats open (or create new shelf) and adds candy there
      candy = self.get_unshelved_candy(candy_name)
      if candy == -1
         puts "candy doesn't exist"
      else
         shelf = self.find_candy_in_shelves(candy_name)
         if shelf == -1
            @shelves[self.find_open_shelf].add_candy(candy)
         else
            @shelves[shelf].add_candy(candy)
         end
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
      @unshelved_names.each {|x| self.shelve_group(x)}
   end

   def print_unshelved
      # prints unshelved list
      puts "Unshelved candies: "
      @unshelved_names.each do |x|
            print x
            print ": "
            puts @unshelved_hash[x].length.to_s
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

list = [Candy.new("mars"),Candy.new("mars"),Candy.new("mars")]
shop1.receive_group(list)
shop1.shelve_group("mars")

shop1.print_shop
