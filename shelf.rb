require_relative 'candy.rb'

class Shelf
   attr_accessor :number, :candy_hash, :total_candies, :shelf_full, :num_candies,
                  :name_array

   def initialize(number)
      @number = number
      @candy_hash = Hash.new{ |h, k| h[k] = []}
      @total_candies = 0
      @shelf_full = 0
      @name_array = Array.new
   end

   def get_index(candy_name)
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
      @name_array.push(candy.name)
      @candy_hash[@name_array.last].push(candy)
      candy.shelve
      @total_candies += 1
   end

   def check_if_exists(candy)
      if @name_array[0] == nil
         return 0
      else
         i = 0
         until i == @name_array.length
            if candy.name == @name_array[i]
               return 1
            end
            i+=1
         end
      end
      return 0
   end

   def check_full
      if @name_array.length == 3
         @shelf_full = 1
      end
   end

   def get_candy_type_count(index)
      return @candy_hash[@name_array[index]].size
   end

   def add_candy(candy)
      bool_check_exists = check_if_exists(candy)
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
      index = get_index(candy_name)
      if index == 4
         return 1
      else
         @candy_hash[@name_array[index]].pop()
         @total_candies -= 1
      end
   end

   def empty_shelf
      @candy_hash.clear()
      @name_array.clear()
      @total_candies = 0
   end

   def print_shelf
      print "shelf "
      print @number
      puts ": "
      i = 0
      until i == @name_array.length
         puts "Candy: " + @name_array[i].to_s
         puts "Amount: " + get_candy_type_count(i).to_s
         i += 1
      end
      puts "total candies: " + @total_candies.to_s
   end

end
