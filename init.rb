require_relative 'shelf.rb'
require_relative 'shop.rb'
require_relative 'candy.rb'
require 'io/console'
$SHELF_CAP

def invalid_entry
   # general error message
   print "ERROR: Invalid Entry. Please try again."
   sleep(1)
end

def invalid_retry_int
   # error message for integer amounts. used for repeating input
   print "Invalid entry. Please enter an amount as an integer: "
end


def opening_prompt
   # this prompt only runs at open to give instructions and set shelf capacity
   puts "WELCOME TO THE CANDY SHOP"
   sleep(1)
   puts " "
   puts "The candy shop works by first taking in candy as inventory."
   puts "The inventory candy can then be moved from inventory onto display shelves"
   puts "and off of display shelves back into inventory. Candy can only be "
   puts "deleted after being placed onto a shelf."
   sleep(3)
   puts " "
   puts "Lets start by saying how many different types of candies each shelf can have."
   puts " "
   print "INPUT SHELF CAPACITY: "
   begin
      $SHELF_CAP = Integer(gets.chomp)
   rescue ArgumentError
      invalid_retry_int
      retry
   end
   puts " "
   puts "Once the max amount of types of candy that can be on a shelf has been"
   puts "reached, a new shelf will be created. A shelf will hold all candies "
   puts "of a single candy name together on a shelf."
   sleep(3)
   puts ' '
   puts "Lets start by adding some candy to our inventory."
end

def instructions
   puts " "
   puts "WELCOME TO THE CANDY SHOP"
   puts "The candy shop works by first taking in candy as inventory."
   puts "The inventory candy can then be moved from inventory onto display shelves"
   puts "and off of display shelves back into inventory. Candy can only be "
   puts "deleted after being placed onto a shelf."
   puts "Once the max amount of types of candy that can be on a shelf has been"
   puts "reached, a new shelf will be created. A shelf will hold all candies "
   puts "of a single candy name together on a shelf."
   puts "SHELF CAPACITY: #{$SHELF_CAP.to_s}"
   puts " "
end

def repeat_prompt(shop1)
   puts "ACTIONS:"
   puts " "
   puts "Press 1 to add more candy to inventory"
   puts "Press 2 to move candy from inventory to shelves"
   if(shop1.no_shelves == $FAIL)
      puts "Press 3 to unshelve candy from shelves and move to inventory"
      puts "Press 4 to remove shelf"
      puts "Press 5 to delete candy"
      puts "Press 6 to exit"
      print "Enter: "
      begin
         check = Integer(STDIN.gets)
      rescue ArgumentError
         invalid_entry
         return check
      end
      if !check.between?(1,6)
         invalid_entry
         return check
      end
   else
      puts "Press 6 to exit"
      print "Enter: "
      begin
         check = Integer(STDIN.gets)
      rescue ArgumentError
         invalid_entry
         return check
      end
      if !check.between?(1,2) && check != 6
         invalid_entry
         return check
      end
   end
   return check
end

def add_candy_prompt(shop1)
   puts " "
   puts "----------------"
   puts "ADDING CANDY TO INVENTORY"
   puts "----------------"
   print "Input name of candy to add: "
   name = gets.chomp
   if !name.match? /\A[a-zA-Z0-9 ]*\z/
      invalid_entry
      return $FAIL
   end
   puts " "
   print "Amount: "
   begin
      amount = Integer(gets.chomp)
   rescue
      invalid_retry_int
      retry
   end
   puts " "
   if add_candy(shop1, name, amount) == $FAIL
      invalid_entry
      return $FAIL
   end
   puts "Adding #{amount} #{name}..."
   sleep(1)
end

def shelve_candy_prompt(shop1)
   puts " "
   puts "----------------"
   puts "SHELVING CANDY"
   puts "----------------"
   print "Enter the name of the candy you wish to shelve: "
   name = gets.chomp
   if shop1.find_unshelved_candy(name) == $FAIL
      puts "Candy not found in inventory. Please try again"
      sleep(1)
      return $FAIL
   end
   print "Enter the amount of candies you wish to shelve: "
   begin
      amount = Integer(gets.chomp)
   rescue ArgumentError
      invalid_retry_int
      retry
   end
   until amount <= shop1.unshelved_candy_type_count(name)
      puts "Amount exceeds total candies in inventory. Please retry: "
      begin
         amount = Integer(gets.chomp)
      rescue ArgumentError
         invalid_entry
         retry
      end
   end
   puts "Shelving #{amount} #{name}..."
   sleep(1)
   shelve(shop1, name, amount)
end

def remove_candy_prompt(shop1)
   puts " "
   puts "----------------"
   puts "UNSHELVING CANDY"
   puts "----------------"
   puts "Which candy would you like to unshelve and move to inventory?"
   name = gets.chomp
   amount = shop1.return_candy_amount(name)
   if amount == $FAIL
      print "Candy not found in shelves. Please try again"
      sleep(1)
      return $FAIL
   end
   printf("There are %d of this type of candy on the shelves", amount)
   puts " "
   puts "How many would you like to move?"
   begin
      amount_to_r = Integer(STDIN.gets)
   rescue ArgumentError
      invalid_retry_int
      retry
   end
   until amount_to_r <= amount
      print "Amount exceeds total candies available to move. Please retry: "
      begin
         amount_to_r = Integer(STDIN.gets)
      rescue ArgumentError
         invalid_retry_int
         retry
      end
   end
   puts "Unshelving #{amount_to_r} #{name}..."
   sleep(1)
   remove_candy(shop1, name, amount_to_r)
end

def remove_shelf_prompt(shop1)
   puts " "
   puts "----------------"
   puts "REMOVING SHELF"
   puts "----------------"
   puts "Which candy would you like to unshelve and move to inventory?"
   if shop1.no_shelves == $SUCCEED
      puts "No shelves"
      sleep(1)
      return $FAIL
   end
   shop1.print_current_shelves
   print "Input the number of the shelf you'd like to remove: "
   begin
      shelf_num = Integer(gets.chomp)
   rescue
      invalid_entry
      sleep(1)
      return $FAIL
   end
   puts " "
   last_shelf = shop1.last_shelf+1
   if !shelf_num.between?(1,last_shelf)
      puts "Shelf does not exist. Please try again"
      sleep(1)
      return $FAIL
   end
   puts "Removing shelf #{shelf_num}..."
   sleep(1)
   shop1.remove_shelf(shelf_num)
end

def delete_candy_prompt(shop1)
   puts " "
   puts "----------------"
   puts "DELETING CANDY"
   puts "----------------"
   puts "Which candy would you like to delete?"
   name = gets.chomp
   amount = shop1.return_candy_amount(name)
   if amount == $FAIL
      print "Candy not found in shelves. Please try again"
      sleep(1)
      return $FAIL
   end
   printf("There are %d of this type of candy on the shelves", amount)
   puts " "
   puts "How many would you like to delete?"
   begin
      amount_to_d = Integer(STDIN.gets)
   rescue ArgumentError
      invalid_retry_int
      retry
   end
   until amount_to_d <= amount
      print "Amount exceeds total candies available to delete. Please retry: "
      begin
         amount_to_r = Integer(STDIN.gets)
      rescue ArgumentError
         invalid_retry_int
         retry
      end
   end
   puts "Deleting #{amount_to_d} #{name}..."
   sleep(1)
   delete_candy(shop1, name, amount_to_d)
end


def add_candy(shop1, candy_name, amount)
   candy = Candy.new(candy_name)
   return $FAIL if shop1.receive_candy(candy, amount) == $FAIL
   return $SUCCESS
end

def shelve(shop1, candy_name, amount)
   until amount == 0
      shop1.shelve_single(candy_name)
      amount -=1
   end
end

def remove_candy(shop1, candy_name, amount)
   until amount == 0
      shop1.unshelve_candy(candy_name)
      amount -= 1
   end
end

def delete_candy(shop1, candy_name, amount)
   until amount == 0
      shop1.delete_candy(candy_name)
      amount -= 1
   end
end

check = 0
shop1 = Shop.new
system("clear")
opening_prompt
add_candy_prompt(shop1)
until check == 6
   system("clear")
   instructions
   shop1.print_shop
   puts ""
   check = repeat_prompt(shop1)
   case check
      when 1
         add_candy_prompt(shop1)
      when 2
         shelve_candy_prompt(shop1)
      when 3
         remove_candy_prompt(shop1)
      when 4
         remove_shelf_prompt(shop1)
      when 5
         delete_candy_prompt(shop1)
      when 6
         break
      else
         next
   end
end
system("clear")
shop1.print_shop
