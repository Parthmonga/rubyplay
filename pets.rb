# demo inheritance
 
require 'minitest/autorun'
 
class TestPetShop < MiniTest::Unit::TestCase
 
  def setup
    @petshop = PetShop.new(
      cat_count: 5,
      fish_count: 3,
    )
  end
 
  def test_subclasses_of_pet
    missing_classes = %w{Cat Dog Fish} - Pet.subclasses.map(&:name)
    assert_equal [], missing_classes
  end
 
   def test_all_the_pets_eat_kibble
     @petshop.pets.each { |pet| assert_equal pet.eat, 'kibble' }
   end
 
  def test_have_fur
    @petshop.pets.each do |pet|
      if pet.class.name == 'Fish'
        assert_equal 'scales', pet.skin_covering
      else
        assert_equal 'fur', pet.skin_covering
      end
    end
  end
 
  def test_pets_make_noise
    @petshop.pets.each do |pet|
      if pet.class.name == 'Fish'
        assert_equal '*bubbles*', pet.speak
      elsif pet.class.name == 'Cat'
        assert_equal 'meow', pet.speak
      elsif pet.class.name == 'Dog'
        assert_equal 'woof', pet.speak
      end
    end
  end
 
  def test_pet_shop_knows_how_many_pets_like_toys
    puts @petshop.pets.count
    assert_equal 7, @petshop.pets_that_like_toys
  end
end
 
class Pet
  @@subclasses = []
  @@pet_likes_toys = 0
 
  def self.inherited(subclass)
    @@subclasses.push subclass
  end
 
  def self.subclasses
    @@subclasses
  end
  
  def self.pets_that_like_toys
    @@pet_likes_toys
  end

  def eat
    'kibble'
  end

  def skin_covering
    'fur'
  end

  def speak
  end

  def likes_toy
    0
  end
end
 
class Cat < Pet
  def speak
    'meow'
  end
end
 
class Fish < Pet
  def skin_covering
    'scales'
  end

  def speak
    '*bubbles*'
  end

  def likes_toy
    1
  end
end
 
class Dog < Pet
  def speak
    'woof'
  end

  def likes_toy
    1
  end
end
 
class PetShop
  def initialize(options={})
    @pets = [Cat.new,Fish.new,Dog.new]
    Pet.subclasses.each do |pet_class|
      number_of_pet = options["#{pet_class.name.downcase}_count".to_sym] || 2
      for index in 1..number_of_pet
        @pets.push pet_class.new
      end
    end
  end
  
  def pets_that_like_toys
    pets_that_like_toys = 0
    @pets.each do |pet|
      pets_that_like_toys = pets_that_like_toys + 1 if pet.likes_toy == 1
    end
    pets_that_like_toys
  end

  def pets
    @pets
  end
end
