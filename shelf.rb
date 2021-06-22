require_relative 'candy.rb'

class Shelf
   attr_accessor :candy_hash, :total_candies, :shelf_full, :name_array

   def initialize() # initializer
      @candy_hash = Hash.new{ |h, k| h[k] = []} # intializes empty 2D hash table that holds all candy objects on shelf
      @total_candies = 0 # counter for total candies on shelf
      @shelf_full = 0 # boolean flag. full status. Shelf is full is candy types == 3. 0 is not full, 1 is full
   end

   def check_full
      # sets shelf_full boolean flag to 1 if we have reached terminal candy type size
      if @candy_hash.keys.length == 3
         @shelf_full = 1
         return 1
      end
      return 0
   end

   def find_candy(candy_name)
      @candy_hash.keys.each {|x| return 1 if x == candy_name}
      return 0
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
      return @candy_hash[candy_name].pop()
   end

   def print_shelf
      # prints all candy names and amount held in shelf
      # print total candies held on shelf
      @candy_hash.keys.each do |x|
         puts "Candy: " + x.to_s
         puts "Amount: " + get_candy_type_count(x).to_s
      end
      puts "total candies: " + @total_candies.to_s
   end

end
