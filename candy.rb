class Candy
   attr_accessor :name, :shelved

   def initialize(name)
      @candy_name = name
      @shelved = 0
   end

   def name
      @candy_name
   end

   def shelved
      @shelved
   end

   def print_name
      puts @candy_name
   end

   def is_shelved
      if @shelved == 0
         puts "not shelved"
      elsif @shelved == 1
         puts "shelved"
      end
   end

   def shelve
      @shelved = 1
   end
   def unshelve
      @shelved = 0
   end
end
