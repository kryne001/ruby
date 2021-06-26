class Candy
   attr_accessor :name, :shelved, :price

   def initialize(name, price) # initialize candy as empty
      @name = name # name of candy
      @shelved = 0 # shelved status (0 means unshelved, 1 means shelved)
      @price = price
   end

   def name # returns name
      @name
   end

   def price
      @price
   end

   def shelved # return shelved status
      @shelved
   end

   def shelve # sets to 1 to signify candy is shelved
      @shelved = 1
   end

   def unshelve # sets to 0 signify candy is unshelved
      @shelved = 0
   end
end
