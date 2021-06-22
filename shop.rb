require_relative 'candy.rb'
require_relative 'shelf.rb'

class Shop
   attr_accessor :shelves, :unshelved_hash, :unshelved_names

   def initialize # initializer
      @shelves = [] # array that holds type Shelf for all shelves in shop
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
      @shelves.each {|x| return @shelves.index(x) if x.check_full == 0}
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
      shelf = self.find_candy_in_shelves(candy_name)
      if shelf == -1
         shelf_new = self.find_open_shelf
         @shelves[shelf_new].add_candy(self.get_unshelved_candy(candy_name))
      else
         @shelves[shelf].add_candy(self.get_unshelved_candy(candy_name))
      end
      @unshelved_hash.delete(candy_name) if @unshelved_hash[candy_name].length == 0
   end

   def shelve_group(candy_name)
      # shelves entire collection of unshelved candy type
      i = @unshelved_hash[candy_name].length
      until i == 0
         self.shelve_single(candy_name)
         i -= 1
      end
   end

   def shelve_all
      # shelves all candies in unshelved list
      @unshelved_hash.keys.each {|x| self.shelve_group(x)}
   end

   def remove_shelf(index)
      @shelves.delete_at(index)
   end

   def unshelve_candy(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      self.receive_candy(@shelves[shelf].remove_candy(candy_name))
      self.remove_shelf(shelf) if @shelves[shelf].candy_hash.keys.length == 0
   end

   def unshelve_group(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      count = @shelves[shelf].get_candy_type_count(candy_name)
      until count == 0
         self.unshelve_candy(candy_name)
         count -= 1
      end
   end

   def unshelve_shelf(index)
      @shelves[index-1].candy_hash.keys.each {|x| self.unshelve_group(x)}
   end

   def unshelve_all
      i = @shelves.length
      until i == 0
         self.unshelve_shelf(i)
         i -= 1
      end
   end

   def print_unshelved
      # prints unshelved list
      total = 0
      if @unshelved_hash.keys.length == 0
         puts "-------------------------"
         puts "No unshelved candies"
         return 0
      else
         puts "-------------------------"
         puts "Unshelved candies: "
         @unshelved_hash.keys.each do |x|
            total += @unshelved_hash[x].length
            print x
            print ": "
            puts @unshelved_hash[x].length.to_s
         end
         print "Total candies unshelved: "
         puts total
         puts "-------------------------"
         return total
      end
   end

   def print_shelved
      # prints all shelves in shop's contents
      total = 0
      @shelves.each do |x|
         total += x.total_candies
         print "Shelf "
         print (@shelves.index(x)+1).to_s
         puts ": "
         x.print_shelf
         puts "-------------------------"
      end
      print "Total candies on shelves: "
      puts total
      puts "-------------------------"
      return total

   end

   def print_shop
      # prints both unshelved list and all shelves in shop's contents
      total_unshelved = self.print_unshelved
      total_shelved = self.print_shelved
      print "Total candies in shop (shelved or unshelved): "
      puts total_unshelved + total_shelved
      puts "-------------------------"
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

shop1.unshelve_all


shop1.print_shop
