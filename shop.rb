require_relative 'candy.rb'
require_relative 'shelf.rb'

$SUCCEED = 1
$FAIL = -1


class Shop
   attr_accessor :shelves, :unshelved_hash, :sold_candies_hash

   def initialize # initializer
      @shelves = [] # array that holds type Shelf for all shelves in shop
      @unshelved_hash = Hash.new{ |h, k| h[k] = []} # 2D hash array that holds all unshelved candies in shop
      @sold_candies_hash = Hash.new{ |h, k| h[k] = []}
   end

   def receive_candy(candy)
      # adds new candy type into unshelved list
      @unshelved_hash[candy.name].push(candy)
   end

   def receive_group(candy_name, price, amount)
      # called if user wants to add an entire bulk shipment of candy
      i = amount
      until i == 0
         newCandy = Candy.new(candy_name, price)
         self.receive_candy(newCandy)
         i -= 1
      end
   end

   def find_candy_in_shelves(candy_name)
      # booleans
      # returns true if candy type has been placed on a shelf
      shelves_indexes = []
      @shelves.each {|x| shelves_indexes << @shelves.index(x) if x.find_candy(candy_name) == $SUCCEED}
      return shelves_indexes if shelves_indexes.length > 0
      return $FAIL
   end

   def create_new_shelf
      puts "Max number of candy types allowed on new shelf: "
      cap = gets.chomp
      @shelves << Shelf.new(cap.to_i)
      return @shelves.index(@shelves.last)
   end

   def find_open_shelf
      # finds shelf that still has room for candy type
      # only called if new candy to be shelved does not exist on other shelves
      # first, parses through existing shelves in shop to find an empty shelf
      # returns index of shelf in @shelves array if shelf contains candy type
      # if not found, creates new shelf, pushes onto @shelves array, and returns index of new shelf in @shelves array
      @shelves.each {|x| return @shelves.index(x) if x.check_full == $FAIL}
      puts "All shelves full. Create new shelf? INPUT: y or n"
      check = STDIN.getch
      case check
         when 'y'
            return self.create_new_shelf
         when 'n'
            return $FAIL
      end
   end

   def find_unshelved_candy(candy_name)
      @unshelved_hash.keys.each {|x| return $SUCCEED if x == candy_name}
      return $FAIL
   end

   def get_unshelved_candy(candy_name)
      return @unshelved_hash[candy_name].pop()
   end

   def return_unshelved_price(candy_name)
      return @unshelved_hash[candy_name][0].price
   end

   def check_if_unshelved_empty
      return $SUCCEED if @unshelved_hash.length == 0
      return $FAIL
   end

   def get_candy_price(candy_name)
      if self.find_unshelved_candy(candy_name) == $SUCCEED
         return self.return_unshelved_price(candy_name)
      else
         shelf = self.find_candy_in_shelves(candy_name)
         return $FAIL if shelf == $FAIL
         return @shelves[shelf[0]].get_candy_price(candy_name)
      end
   end

   def shelve_single(candy_name)
      # adds single candy to shelf
      # takes in desired candy to shelve as argument
      # first, gets desired candy from unshelved list (method ends if candy doesnt exist)
      # next, check if desired candy type has already been placed on a shelf
      # if yes, adds candy to shelf
      # if no, finds a shelf thats open (or create new shelf) and adds candy there
      return $FAIL if self.find_unshelved_candy(candy_name) == $FAIL
      shelves_indexes = self.find_candy_in_shelves(candy_name)
      if shelves_indexes == $FAIL
         shelf_new = self.find_open_shelf
         if shelf_new == $FAIL
            return $FAIL
         end
         @shelves[shelf_new].add_candy(self.get_unshelved_candy(candy_name))
      else
         print candy_name
         print " found in shelves "
         shelves_indexes.each do |x|
            print x+1.to_s
            print " "
         end
         puts " "
         puts "1 to place on one of these shelves"
         puts "2 to place on new shelf"
         answer = STDIN.getch
         case answer
            when '1'
               puts "Enter shelf to place candy on: "
               i = $FAIL
               until i == $SUCCEED
                  shelf_num = gets.chomp
                  shelves_indexes.each {|x| i = $SUCCEED if x == shelf_num.to_i}
                  puts "invalid entry, please try again" if i == $FAIL
               end
               @shelves[shelf_num.to_i-1].add_candy(self.get_unshelved_candy(candy_name))
            when '2'
               new_shelf_index = self.create_new_shelf
               @shelves[new_shelf_index].add_candy(self.get_unshelved_candy(candy_name))
            end

      end
      @unshelved_hash.delete(candy_name) if @unshelved_hash[candy_name].length == 0
   end

   def shelve_group(candy_name)
      # shelves entire collection of unshelved candy type
      i = @unshelved_hash[candy_name].length
      until i == 0
         return $FAIL if self.shelve_single(candy_name) == 0
         i -= 1
      end
   end

   def shelve_all
      # shelves all candies in unshelved list
      @unshelved_hash.keys.each {|x| self.shelve_group(x)}
   end

   def remove_shelf(index)
      return $FAIL if @shelves[index] == nil
      @shelves.delete_at(index)
   end

   def unshelve_candy(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      return $FAIL if shelf == $FAIL
      self.receive_candy(@shelves[shelf].remove_candy(candy_name))
      self.remove_shelf(shelf) if @shelves[shelf].candy_hash.keys.length == 0
   end

   def unshelve_group(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      return $FAIL if shelf == $FAIL
      count = @shelves[shelf].get_candy_type_count(candy_name)
      until count == 0
         self.unshelve_candy(candy_name)
         count -= 1
      end
   end

   def unshelve_shelf(index)
      return $FAIL if @shelves[index] == nil
      @shelves[index-1].candy_hash.keys.each {|x| self.unshelve_group(x)}
   end

   def unshelve_all
      i = @shelves.length
      return $FAIL if i == 0
      until i == 0
         self.unshelve_shelf(i)
         i -= 1
      end
   end

   def sell_candy(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      return $FAIL if shelf == $FAIL
      @sold_candies_hash[candy_name].push(self.unshelve_candy(candy_name)) if shelf != -1
   end

   def sell_list(list)
      # example list [[twix, 2], [snickers, 3], [food,4]]
      i = list[1].to_i
      until i == 0
         return $FAIL if self.sell_candy(list[0]) == $FAIL
         i -= 1
      end
   end

   def print_unshelved
      # prints unshelved list
      total = 0
      if @unshelved_hash.keys.length == 0
         puts "-------------------------"
         puts "No unshelved candies"
         puts "-------------------------"
         return 0
      else
         puts "-------------------------"
         puts "Unshelved candies: "
         @unshelved_hash.keys.each do |x|
            total += @unshelved_hash[x].length
            print x
            print ": "
            puts @unshelved_hash[x].length.to_s
            print "Price: $"
            puts @unshelved_hash[x][0].price
            puts " "
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
      if @shelves.length == 0
         puts "There are currently no candies on any shelf"
         return 0
      else
         puts "-------------------------"
         puts "Current shelves contents:"
         puts "xxxx"
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
   end

   def print_sold
      total = 0
      if @sold_candies_hash.keys.length == 0
         puts "-------------------------"
         puts "No sold candies"
         puts "-------------------------"
         return 0
      else
         puts "-------------------------"
         puts "Sold candies: "
         @sold_candies_hash.keys.each do |x|
            total += @sold_candies_hash[x].length
            print x
            print ": "
            puts @sold_candies_hash[x].length.to_s
         end
         print "Total candies sold: "
         puts total
         puts "-------------------------"
         return total
      end   end

   def print_shop
      # prints both unshelved list and all shelves in shop's contents
      total_unshelved = self.print_unshelved
      total_shelved = self.print_shelved
      print "Total candies in shop (shelved or unshelved): "
      puts total_unshelved + total_shelved
      puts "-------------------------"
      self.print_sold
   end

end
