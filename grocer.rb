require 'byebug'
def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |item_name, item_data|
      if new_cart[item_name]
        new_cart[item_name][:count] += 1
      else
        new_cart[item_name] = item_data
        new_cart[item_name][:count] = 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        if !cart.keys.include?("#{coupon[:item]} W/COUPON")
          cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost] / coupon[:num], :clearance => cart[coupon[:item]][:clearance], :count => coupon[:num] }
          cart[coupon[:item]][:count] -= coupon[:num]
        else
          cart["#{coupon[:item]} W/COUPON"][:count] += coupon[:num]
          cart[coupon[:item]][:count] -= coupon[:num]
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, item_data|
    if item_data[:clearance]
      cart[item_name][:price] -= cart[item_name][:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearanced_cart = apply_clearance(couponed_cart)
  clearanced_cart.each do |item_name, item_data|
    total += item_data[:price] * item_data[:count]
  end
  if total > 100
    total -= total * 0.1
  end
  total
end

#30 mins so far
