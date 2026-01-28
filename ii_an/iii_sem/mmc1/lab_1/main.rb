#!/bin/ruby
# frozen_string_literal: true

require 'benchmark'
require 'rubocop'

def f(x)
    # 2*(x - 1)**2 - Math::E**x # 14f1
    x**3 + 20*x - 41          # 14f2
    # Math.cos(x) + 2 * x - 0.5 # 19f1
    # x ** 3 - 26 * x + 43      # 19f2
end

def fi(x)
    # (2*x**2+2-Math::E**x)/4.to_f # 14f1
    (x**3 - 41)/ -20             # 14f2
    # (Math.cos(x) - 0.5)/ -2      # 19f1
    # (x ** 3 + 43)/ -26           # 19f2
end

def df(x)
    # 4*(x - 1) - Math::E*x        # 14f1
    3 * x ** 2 + 20              # 14f2
    # 2 - Math.sin(x)              # 19f1
    # 3 * x ** 2 - 26              # 19f2
end


def bisect(a, b, eps)
  c = a
  c = b if f(a).negative?
  d = a + b - c
  k = error = 0
  until (c - d).abs <= eps
    x = c + (d - c) / 2.to_f
    k += 1
    fx = f(x)
    break if fx.zero?

    fx.positive? ? c = x : d = x
    error = (c - d).abs
  end
  { x: x, k: k, error: error }
end

def siter(a, eps, nmax)
  x = k = error = 0
  y = a
  until (y - x).abs <= eps || k >= nmax
    k += 1
    x = y
    y = fi(x)
    error = y - x
  end
  error = (y - x).abs
  tf = k < nmax
  x1 = x
  { x: x1, k: k, error: error, tf: tf }
end

# def siter(p1, p2, eps, nmax)
#     k = 0
#     x1 = (p1 + p2)/2.0.to_f
#     x2 = x1 + 0.1*f(x1)
#     error = (x1 - x2).abs
#     until ((x1 - x2).abs < eps || k > nmax)
#         x1 = x2
#         x2 += 0.1*f(x1)
#         k += 1
#     end
#      { :x => x1, :k => k, :error => error }
# end

def newton(a, eps, nmax)
  x1 = a
  x0 = k = error = 0
  until (x1 - x0).abs <= eps || k >= nmax
    k += 1
    x0 = x1
    x1 = x0 - (f(x0).to_f / df(x0))
    error = (x1 - x0).abs
  end
  { x: x0, k: k, error: error }
end

# #################################19f2##################################
#
# puts 'For f(x)=x^3 - 26x + 43 && roots: 1.[-6, -5] 2.[1, 2] 3.[3, 4]'
# puts "\nBisect\n"
# p r1b = bisect(-6, -5, 10**-6)
# p r2b = bisect(1, 2, 10**-6)
# p r3b = bisect(3, 4, 10**-6)

# puts "\nNewton\n"
# p r1n = newton(-6, 10**-6, 100)
# p r1n = newton(1, 10**-6, 100)
# p r1n = newton(3, 10**-6, 100)

# puts "\nSiter\n"
# p r1s = siter(-6, 10**-6, 100)
# p r2s = siter(1, 10**-6, 100)
# p r3s = siter(3, 10**-6, 100)

# puts ''
# Benchmark.bm do |x|
#  x.report('Bisect') { 100_000.times { bisect(-6, -5, 10**-4) } }
#  x.report('Newton') { 100_000.times { newton(-6, 10**-4, 50) } }
#  x.report('Siter ') { 100_000.times { siter(-6, 10**-4, 50) } }
# end

# #################################19f1##################################

# puts "For f(x)=cos(x) + 2x - 0.5 && roots: 1.[-1, 0]"
# puts "\n[Bisect] #{ r1b = bisect(-1, 0, 10**-6) }"  +
#      "\n[Newton] #{ r1n = newton(-1, 10**-6, 50) }" +
#      "\n[Siter ] #{ r1s = siter(-1, 10**-6, 50) }\n\n"

# #################################14f1##################################

# puts "For f(x)=2(x - 1)^2 - e^x && roots: 1.[-1, 0]"
# puts "\n[Bisect] #{ r1b = bisect(0, 1, 10**-6) }"  +
#      "\n[Newton] #{ r1n = newton(1, 10**-6, 50) }" +
#      "\n[Siter ] #{ r1s = siter(1, 10**-6, 50) }\n\n"

# #################################14f2##################################

puts "For f(x)=x^3 +20x -41 && roots: 1.[-1, 0]"
puts "\n[Bisect] #{ r1b = bisect(0, 2, 10**-6) }"  +
     "\n[Newton] #{ r1n = newton(2, 10**-6, 50) }" +
     "\n[Siter ] #{ r1s = siter(2, 10**-6, 50) }\n\n"

Benchmark.bm do |x|
  x.report("Bisect") { 100_000.times { bisect(-1, 0, 10**-4) } }
  x.report("Newton") { 100_000.times { newton(-1, 10**-4, 50) } }
  x.report("Siter ") { 100_000.times { siter(-1, 10**-4, 50) } }
end
