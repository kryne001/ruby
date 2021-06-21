require_relative 'candy.rb'

class Shelf
   attr_accessor :candy_hash, :total_candies, :shelf_full, :name_array

   def initialize() # initializer
      @candy_hash = Hash.new{ |h, k| h[k] = []} # intializes empty 2D hash table that holds all candy objects on shelf
      @total_candies = 0 # counter for total candies on shelf
      @shelf_full = 0 # boolean flag. full status. Shelf is full is candy types == 3. 0 is not full, 1 is full
      @name_array = Array.new # array of strings that holds name of types of candy in shelf. Used for indexing for hash and checking types of candy
   end

   def get_index(candy_name)
      # returns index in name_array of candy type's name if it exists, returns 4 if doesn't exist
      if @name_array.length == 0
         return 4
      end
      i = 0
      until candy_name == @name_array[i]
         i+=1
      end
      if candy_name == @name_array[i]
         return i
      else
         return 4
      end
   end

   def push_existing_candy(candy)
      # pushes candy assuming that other candies of same type already exist in candy_hash
      i = 0
      until i > @name_array.length
         if candy.name == @name_array[i]
            @candy_hash[@name_array[i]].push(candy)
         end
         i += 1
      end
      candy.shelve
      @total_candies += 1
   end

   def push_new_candy(candy)
      # pushes candy assuming that no other candies of same type already exist in candy_hash
      @name_array.push(candy.name)
      @candy_hash[@name_array.last].push(candy)
      candy.shelve
      @total_candies += 1
   end

   def check_if_exists(candy_name)
      # boolean, returns 1 for true if candy is already on shelf, returns 0 if no
      if @name_array[0] == nil
         return 0
      else
         @name_array.each {|x| return 1 if x == candy_name}
      end
      return 0
   end

   def check_full
      # sets shelf_full boolean flag to 1 if we have reached terminal candy type size
      if @name_array.length == 3
         @shelf_full = 1
      end
   end

   def get_candy_type_count(index)
      # returns length in int of column of candies in 2D hash to signify total candies of single type
      return @candy_hash[@name_array[index]].size
   end

   def add_candy(candy)
      # adds single candy to shelf
      # checks first if candy type is already on shelf, if true will call push_existing_candy to push in right part of table
      # if false, will check to see if there's room on shelf, if there is will create new hash key and start list of new candy type
      # if no room on shelf, return 1 to signify fail
      bool_check_exists = check_if_exists(candy.name)
      if bool_check_exists == 1
         self.push_existing_candy(candy)
      elsif bool_check_exists == 0
         self.check_full
         if @shelf_full == 1
            puts "shelf full, cannot add candy"
            return 1
         else
            self.push_new_candy(candy)
         end
      end
   end

   def remove_candy(candy_name)
      # removes single candy from shelf
      # will call get_index to find index in hash of candy type
      # if found, will decrement total_candies count by 1, pop candy from hash, and return popped candy for shop file
      # if not found, will return 1 to signify fail
      index = get_index(candy_name)
      if index == 4
         return 1
      else
         @total_candies -= 1
         return @candy_hash[@name_array[index]].pop()
      end
   end

   def print_shelf
      # prints all candy names and amount held in shelf
      # print total candies held on shelf
      i = 0
      until i == @name_array.length
         puts "Candy: " + @name_array[i].to_s
         puts "Amount: " + get_candy_type_count(i).to_s
         i += 1
      end
      puts "total candies: " + @total_candies.to_s
   end

end
