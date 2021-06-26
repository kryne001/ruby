require_relative 'shelf.rb'
require_relative 'shop.rb'
require_relative 'candy.rb'
require 'io/console'

$SUCCEED = 1
$FAIL = -1

def opening_prompt
   puts "******************"
   puts "1 to add candy"
   puts "2 to shelve candy"
   puts "3 to unshelve candy"
   puts "4 sell candy"
   puts "x to end: "
   check = STDIN.getch
   puts "******************"
   return check
end

def add_candy_choice_prompt(shop1)
   puts "1 to add single candy"
   puts "2 to add multiple candies"
   puts "b to return back"
   check = STDIN.getch
   case check
      when '1'
         receive_single_candy(shop1)
      when '2'
         receive_multiple_candies(shop1)
      when 'b'
         return
   end
end

def shelve_choice_prompt(shop1)
   if shop1.check_if_unshelved_empty == 0
      puts "ERROR: No candies to shelve"
      sleep(1)
   else
      puts "1 to shelve a single candy"
      puts "2 to shelve multiple candies of a single type"
      puts "3 to shelve all unshelved candies"
      puts "b to go back"
      input = STDIN.getch
      case input
         when '1'
            shelve_single_candy(shop1)
         when '2'
            shelve_all_candy_type(shop1)
         when '3'
            shelve_all_candies(shop1)
         when 'b'
            return
      end
   end
end

def unshelve_choice_prompt(shop1)
   puts "1 to unshelve single candy"
   puts "2 to unshelve all of a type of candy"
   check = STDIN.getch
   case check
      when '1'
         unshelve_single(shop1)
      when '2'
         unshelve_group(shop1)
   end
end

def receive_single_candy(shop)
   print "Enter type of candy (input b to go back): "
   candy = gets.chomp
   return if candy == "b"
   price = shop.get_candy_price(candy)
   if shop.get_candy_price(candy) == $FAIL
      print "Enter price of candy: "
      price = gets.chomp
   end
   newCandy = Candy.new(candy, price.to_f)
   shop.receive_candy(newCandy)
end

def receive_multiple_candies(shop1)
   candy_name = ""
   until candy_name == "stop"
      print "Candy type (input stop to end): "
      candy_name = gets.chomp
      return if candy_name == "stop"
      print "Amount: "
      candy_amount = gets.chomp
      candy_price = shop1.get_candy_price(candy_name)
      if  candy_price == $FAIL
         print "Price of candy: "
         candy_price = gets.chomp
      end
      shop1.receive_group(candy_name, candy_price.to_f, candy_amount.to_i)
      puts " "
   end
end

def shelve_single_candy(shop1)
   print "Candy: "
   candy = gets.chomp
   if shop1.shelve_single(candy) == $FAIL
      puts "Invalid entry"
      sleep(1)
   end
end

def shelve_all_candy_type(shop1)
   print "Candy: "
   candy = gets.chomp
   if shop1.shelve_group(candy) == $FAIL
      puts "ERROR: Invalid entry"
      sleep(1)
   end
end

def shelve_all_candies(shop1)
   shop1.shelve_all
end

def unshelve_single(shop1)
   print "Candy: "
   candy = gets.chomp
   if shop1.find_candy_in_shelves(candy) == $FAIL
      puts "ERROR: Invalid Entry"
      sleep(1)
      return $FAIL
   end
   shop1.unshelve_candy(candy)
end

def unshelve_group(shop1)
   print "Candy: "
   candy = gets.chomp
   if shop1.find_candy_in_shelves(candy) == $FAIL
      puts "ERROR: Invalid Entry"
      sleep(1)
      return $FAIL
   end
   shop1.unshelve_group(candy)
end

check = ''
shop1 = Shop.new
system("clear")
shop1.print_shop
until check == 'x'
   check = opening_prompt
   case check
      when '1'
         add_candy_choice_prompt(shop1)
      when '2'
         shelve_choice_prompt(shop1)
      when '3'
         unshelve_choice_prompt(shop1)
   end
   system("clear")
   shop1.print_shop


end
