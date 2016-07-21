# print every number
# except if its a multiple of 3, print fizz
# multiple of 5 print buzz
# multiple of 3 & 5 brint 'fizzbuzz'

(1.100).each do |number|
  output = ''
  output << 'fizz' if number % 3 == 0
  output << 'buzz' if number % 5 == 0
  output << number.to_s if output == ''
end