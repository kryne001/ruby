require_relative 'candy.rb'

$SUCCEED = 1
$FAIL = -1

class Shelf
   attr_accessor :candy_hash, :total_candies, :capacity

   def initialize(cap) # initializer
      @candy_hash = Hash.new{ |h, k| h[k] = []} # intializes empty 2D hash table that holds all candy objects on shelf
      @total_candies = 0 # counter for total candies on shelf
      @capacity = cap
   end

   def check_full
      # sets shelf_full boolean flag to 1 if we have reached terminal candy type size
      if @candy_hash.keys.length == @capacity
         return $SUCCEED
      end
      return $FAIL
   end

   def find_candy(candy_name)
      @candy_hash.keys.each {|x| return $SUCCEED if x == candy_name}
      return $FAIL
   end

   def get_candy_type_count(key)
      # returns length in int of column of candies in 2D hash to signify total candies of single type
      return @candy_hash[key].size
   end

   def add_candy(candy)
      @candy_hash[candy.name].push(candy)
      @total_candies += 1
   end

   def remove_candy(candy_name)
      @total_candies -= 1
      candy = @candy_hash[candy_name].pop()
      @candy_hash.delete(candy_name) if @candy_hash[candy_name].length == 0
      return candy
   end

   def get_candy_price(candy_name)
      return $FAIL if self.find_candy(candy_name) == $FAIL
      return @candy_hash[candy_name][0].price
   end

   def print_shelf
      # prints all candy names and amount held in shelf
      # print total candies held on shelf
      @candy_hash.keys.each do |x|
         printf("%10s", "Candy: ")
         puts x.rjust(15)
         # print "Candy: ".rjust(5)
         # printf("Candy: ", "%20d", x)
         printf("%10s", "Amount: ")
         puts get_candy_type_count(x).to_s.rjust(15)
         puts " "
      end
      printf("%10s", "Total: ")
      puts @total_candies.to_s.rjust(15)
   end

end
