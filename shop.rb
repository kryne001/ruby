require_relative 'candy.rb'
require_relative 'shelf.rb'
$SHELF_CAP

class Shop
   attr_accessor :shelves, :unshelved_hash, :sold_candies_hash

   def initialize # initializer
      @shelves = [] # array that holds type Shelf for all shelves in shop
      @unshelved_hash = Hash.new{ |h, k| h[k] = []} # 2D hash array that holds all unshelved candies in shop
      @sold_candies_hash = Hash.new{ |h, k| h[k] = []}
   end

   def invalid_entry
      puts "ERROR: Invalid Entry"
      sleep(1)
   end

   def receive_candy(candy, amount)
      # adds new candy type into unshelved list
      until amount == 0
         @unshelved_hash[candy.name].push(candy)
         amount -= 1
      end
   end

   def find_candy_in_shelves(candy_name)
      # booleans
      # returns true if candy type has been placed on a shelf
      @shelves.each {|x| return @shelves.index(x) if x.find_candy(candy_name) == $SUCCEED}
      return $FAIL
   end

   def create_new_shelf
      @shelves << Shelf.new($SHELF_CAP)
      shelf_number = @shelves.index(@shelves.last)
      shelf_print = shelf_number.to_i
      shelf_print += 1
      print "Creating shelf "
      puts shelf_print.to_s
      sleep(1)
      return shelf_number
   end

   def find_open_shelf
      # finds shelf that still has room for candy type
      # only called if new candy to be shelved does not exist on other shelves
      # first, parses through existing shelves in shop to find an empty shelf
      # returns index of shelf in @shelves array if shelf contains candy type
      # if not found, creates new shelf, pushes onto @shelves array, and returns index of new shelf in @shelves array
      if @shelves.length == 0
         return self.create_new_shelf
      end
      @shelves.each {|x| return @shelves.index(x) if x.check_full == $FAIL}
      return self.create_new_shelf
   end

   def find_unshelved_candy(candy_name)
      @unshelved_hash.keys.each {|x| return $SUCCEED if x == candy_name}
      return $FAIL
   end

   def unshelved_candy_type_count(candy_name)
      return @unshelved_hash[candy_name].length
   end

   def no_shelves
      return $SUCCEED if @shelves.length == 0
      return $FAIL
   end

   def return_shelf(index)
      @shelves.each {|x| return $SUCCEED if @shelves.index(x) == index}
      return $FAIL
   end

   def get_unshelved_candy(candy_name)
      return $FAIL if @unshelved_hash[candy_name] == nil
      return @unshelved_hash[candy_name].pop()
   end

   def check_if_unshelved_empty
      return $SUCCEED if @unshelved_hash.length == 0
      return $FAIL
   end

   def get_shelf
      return @shelves.index(@shelves.last)
   end

   def delete_candy_unshelved(candy_name)
      @unshelved_hash.delete(candy_name) if @unshelved_hash[candy_name].length == 0
   end

   def shelve_single(candy_name)
      unshelved_candy = self.get_unshelved_candy(candy_name)
      return $FAIL if unshelved_candy == $FAIL
      current_index = self.find_candy_in_shelves(candy_name)
      if current_index == $FAIL
         current_index = self.find_open_shelf
         return $FAIL if current_index == $FAIL
      end
      @shelves[current_index].add_candy(unshelved_candy)
      self.delete_candy_unshelved(candy_name)
      return $SUCCESS
   end

   def shelve_group(candy_name)
      i = @unshelved_hash[candy_name].length
      until i == 0
         return $FAIL if self.shelve_single(candy_name) == $FAIL
         i -= 1
      end
   end

   def remove_shelf(index)
      return $FAIL if @shelves[index] == nil
      @shelves.delete_at(index)
   end

   def unshelve_candy(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      return $FAIL if shelf == $FAIL
      self.receive_candy(@shelves[shelf].remove_candy(candy_name),1)
      @shelves.delete_at(shelf) if @shelves[shelf].candy_hash.keys.length == 0
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

   def remove_shelf(index)
      return $FAIL if @shelves[index-1] == nil
      @shelves[index-1].candy_hash.keys.each {|x| self.unshelve_group(x)}
   end

   def return_candy_amount(candy_name)
      shelf_num = self.find_candy_in_shelves(candy_name)
      return $FAIL if shelf_num == $FAIL
      return @shelves[shelf_num].get_candy_type_count(candy_name)
   end

   def print_current_shelves
      print "Current shelves: "
      @shelves.each do |x|
         print @shelves.index(x) + 1
         print " "
      end
      puts " "
   end

   def last_shelf
      return @shelves.index(@shelves.last)
   end

   def delete_candy(candy_name)
      shelf = self.find_candy_in_shelves(candy_name)
      return $FAIL if shelf == $FAIL
      @shelves[shelf].remove_candy(candy_name)
      @shelves.delete_at(shelf) if @shelves[shelf].candy_hash.keys.length == 0
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
         puts " "
         @unshelved_hash.keys.each do |x|
            total += @unshelved_hash[x].length
            puts x.ljust(15) +  @unshelved_hash[x].length.to_s
         end
         puts " "
         puts "-------------------------"
         return total
      end
   end


   def print_shelved
      # prints all shelves in shop's contents
      total = 0
      if @shelves.length == 0
         puts "There are currently no shelves"
         puts "-------------------------"
         return 0
      else
         puts "-------------------------"
         puts "Current shelves contents:"
         puts " "
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

   def print_shop
      # prints both unshelved list and all shelves in shop's contents
      total_unshelved = self.print_unshelved
      total_shelved = self.print_shelved
      puts "Total candies unshelved:     #{total_unshelved}"
      puts "Total candies shelved:       #{total_shelved}"
      puts "-------------------------"
      puts ""
   end

end
