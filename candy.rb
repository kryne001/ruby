$SUCCEED = 1
$FAIL = -1
$SHELF_CAP

class Candy
   attr_accessor :name, :shelved, :price

   def initialize(name) # initialize candy as empty
      @name = name # name of candy
   end
end
