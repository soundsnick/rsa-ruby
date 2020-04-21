require "prime"

def random_prime_number
  number = Random.rand(10..100)
  until Prime.prime?(number) do
    number = Random.rand(10..100)
  end
  number
end

def e(fi)
  fi.downto(2).find do |i|
    Prime.prime?(i) && fi % i != 0
  end
end

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  raise 'The maths are broken!' if g != 1
  x % et
end

def generate_keys
  def init
    @p = random_prime_number
    @q = random_prime_number
    @n = @p*@q
    @fi = (@p-1)*(@q-1)
    @e = e @fi
    @d = invmod(@e, @fi)
    if @e == @d
      puts "Error: e=d. Reinitializing..."
      init
    end
  end
  init
  File.open("./keys/public.key", "w") {|f| f.write("#{@e},#{@n}") }
  File.open("./keys/private.key", "w") {|f| f.write("#{@d},#{@n}") }
  puts "Keys are generated: public.key, private.key"
  "#{@e},#{@n}|#{@d},#{@n}"
end
# Uncomment to work from terminal
# generate_keys
