require_relative 'candy.rb'
$SHELF_CAP

class Shelf
   attr_accessor :candy_hash, :total_candies, :capacity

   def initialize(cap) # initializer
      @candy_hash = Hash.new{ |h, k| h[k] = []} # intializes empty 2D hash table that holds all candy objects on shelf
      @total_candies = 0 # counter for total candies on shelf
      @capacity = cap # capacity of shelf
   end

   def check_full
      # sets shelf_full boolean flag to SUCCEED if we have reached terminal candy type size
      return $SUCCEED if @candy_hash.keys.length == @capacity
      return $FAIL
   end

   def find_candy(candy_name)
      # returns SUCCEED if candy is on shelf
      @candy_hash.keys.each {|x| return $SUCCEED if x == candy_name}
      return $FAIL
   end

   def get_candy_type_count(key)
      # returns length in int of column of candies in 2D hash to signify total candies of single type
      return @candy_hash[key].size
   end

   def add_candy(candy)
      # adds candy to hash table of candies in shelf
      @candy_hash[candy.name].push(candy)
      @total_candies += 1
   end

   def remove_candy(candy_name)
      # pops candy from list and returns the popped candy
      # will delete candy type from shelf if there are no more of type 
      @total_candies -= 1
      candy = @candy_hash[candy_name].pop()
      @candy_hash.delete(candy_name) if @candy_hash[candy_name].length == 0
      return candy
   end

   def print_shelf
      # prints all candy names and amount held in shelf
      # print total candies held on shelf
      longest = @candy_hash.keys.flatten.map do |x|
         x.size
      end.max
      @candy_hash.keys.each do |x|
         puts "   Candy:           #{x.rjust(longest)}"
         puts "   Amount:          #{get_candy_type_count(x).to_s.rjust(longest)}"
         puts " "
      end
      puts "   Total:           #{@total_candies.to_s.rjust(longest)}"
      puts
   end

end
