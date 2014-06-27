require 'rubygems'
require 'json'
require 'open-uri'

puts "Paste the public URL to your file!"
url = gets
file = open(url)

#create array of lines
menu_list = []
file.each_line do |line|
  menu_list.push(line)
end

#grab first line, and turn to float
target_total = menu_list[0].tr('$', '').to_f

#create hash of price => name
menu_list.delete_at(0)

items = Hash.new


menu_list.each do |list_item|
  item_array = list_item.split(",")
  name = item_array[0]
  price = item_array[1].tr('$', '').to_f
  hash = Hash[price, name]
  items.merge!(hash)
end


test_dishes = {2=>"poop", 5=>"meep", 4=>"boop", 3=>"loop"}



def pricecheck(dishes, desired_sum)
  #grab lowest price and determine maximum possible number of items
  sorted = dishes.sort
  lowest_priced = sorted.first
  maximum = desired_sum / lowest_priced[0]
  maximum_no_of_items = maximum.ceil - 1
  prices = dishes.keys

  #create array including most number of items possible of each item (allow for duplicates)
  full_array = []

  prices.each do |price|
    max = desired_sum / price
    max_num = max.ceil
    (0..max_num).each{|x|
      full_array.push(price)
    }
  end

  prices_of_dishes = full_array

  #test possible combos with dulpicates
  if desired_sum == 0
    puts "No money, more problems. You can't get something for nothing!"
  else
    number = 1
    combos = Hash.new
    (0..maximum_no_of_items).each{|possible_number_of_dishes|
      prices_of_dishes.combination(possible_number_of_dishes).each{|this_combo|
        if this_combo.inject(:+) == desired_sum
          key = "Combination " + number.to_s
          value = []
          this_combo.each do |one_price|
            value.push(dishes[one_price])
          end
        hash = Hash[key, value]
        combos.merge!(hash)
        number = number + 1
      end
      }
    }
    if combos.length == 0
      puts "No combinations for that amount of cash, sorry!"
    else
      com_number = 1
      possible_combos = combos.values.uniq
      number_of_possible_combos = possible_combos.count
      puts "There are " + number_of_possible_combos.to_s + " combinations for $" + desired_sum.to_s
      possible_combos.each do |combo|
        puts "Combo " + com_number.to_s + ":"
        item_names = combo.uniq
        item_names.each do |item|
          puts "#{combo.count(item)} #{item}"
        end
        com_number = com_number + 1
      end
    end
  end
end


pricecheck(items, target_total)
# pricecheck(test_dishes, 6)



