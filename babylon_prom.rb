
class Checkout

	def initialize(promotional_rules)

		@prom_rules = promotional_rules
		@scanned_items = Hash.new

	end

	def scan(scanned_item)

		if @scanned_items.key?(scanned_item)

			@scanned_items[scanned_item] += 1

		else
			@scanned_items[scanned_item] = 1
		end

  end

  def total

  	running_total = 0.0

  	@scanned_items.keys.each do |item|

  		price_per_item = 0.0

  		if (@prom_rules[item].key?('bulk_discount')) && (@scanned_items[item] > 1)

  			price_per_item = get_bulk_price(item)

  		else
  			price_per_item = @prom_rules[item]['base_price']
  		end

  		total_price_for_all_of_this_item = price_per_item * @scanned_items[item]

  		running_total += total_price_for_all_of_this_item

  	end

  	discount_to_be_applied = discount_applied(running_total)

  	return (running_total * (1.0 - discount_to_be_applied)).round(2)

  end

private

  def get_bulk_price(item)

  	ret_val = @prom_rules[item]['base_price']

  	if @prom_rules[item]['bulk_discount'].key?(@scanned_items[item])

  		ret_val = @prom_rules[item]['bulk_discount'][@scanned_items[item]]

  	else

  		number_of_items = @scanned_items[item]

  		@prom_rules[item]['bulk_discount'].keys.each do |minimum_bulk|

  			if number_of_items >= minimum_bulk
  				ret_val = @prom_rules[item]['bulk_discount'][minimum_bulk]
  			end

  		end

  	end

  	return ret_val

  end

  def discount_applied(total_before_any_discount)

  	ret_val = 0.0

  	if @prom_rules['GEN'].key?('total_discount')

  		@prom_rules['GEN']['total_discount'].keys.each do |minimum_total|

  			if total_before_any_discount >= minimum_total
  				ret_val = @prom_rules['GEN']['total_discount'][minimum_total]
  			end

  		end

  	end

  	return ret_val

	end

end




