require_relative 'candy.rb'

class Shelf
   attr_accessor :number, :candy_array, :total_candies, :shelf_full, :num_candies,
                  :name_array

   def initialize(number)
      @number = number
      @candy_array = [[],[],[]]
      @total_candies = 0
      @shelf_full = 0
      @name_array = Array.new
   end

   def push_existing_candy(candy)
      i = 0
      until i > @name_array.length
         if candy.name == @name_array[i]
            @candy_array[i].push(candy)
         end
         i += 1
      end
      candy.shelve
      @total_candies += 1
   end

   def push_new_candy(candy,index)
      @candy_array[index].push(candy)
      @name_array.push(candy.name)
      candy.shelve
      @total_candies += 1
   end

   def check_if_exists(candy)
      if @name_array[0] == nil
         return 0
      else
         i = 0
         until i > @name_array.length
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
      i = 0
      until i > @candy_array[index].length - 1
         i += 1
      end
      return i
   end

   def add_candy(candy)
      bool_check_exists = check_if_exists(candy)
      if bool_check_exists == 1
         self.push_existing_candy(candy)
      elsif bool_check_exists == 0
         self.check_full
         if @shelf_full == 1
            puts "shelf full, cannot add candy"
         else
            self.push_new_candy(candy, @name_array.length)
         end
      end
   end

   def print_shelf
      i = 0
      until i > @name_array.length - 1
         print "Candy: "
         puts @candy_array[i][0].name
         print "Amount: "
         puts get_candy_type_count(i)
         i += 1
      end
      print "total candies: "
      puts @total_candies
   end

end

   shelf1 = Shelf.new(1)
   shelf1.add_candy(Candy.new("twix"))
   shelf1.add_candy(Candy.new("twix"))
   shelf1.add_candy(Candy.new("snickers"))
   shelf1.add_candy(Candy.new("snickers"))
   shelf1.add_candy(Candy.new("snickers"))
   shelf1.add_candy(Candy.new("snickers"))
   shelf1.add_candy(Candy.new("mars"))
   shelf1.add_candy(Candy.new("mars"))
   shelf1.add_candy(Candy.new("mars"))
   shelf1.add_candy(Candy.new("mars"))
   shelf1.add_candy(Candy.new("mars"))
   shelf1.add_candy(Candy.new("mars"))


   shelf1.print_shelf
   # shelf1.add_candy(Candy.new("twix"))
