#!/bin/ruby
# frozen_string_literal: true

# gem install text-table
require 'text-table'
# gem install matplotlib -v 1.1.0
require 'matplotlib/pyplot'
require "csv"

@var = 14
@var = 19
@var = '_ex'
puts "varianta #{@var}"

if @var == 14
  @a = 1
  @a1 = @a + 1
  @y0 = 3
  @h = 0.05
elsif @var == 19
  @a = 0
  @a1 = @a + 1
  @y0 = 2
  @h = 0.05
else
  @a = 0
  @a1 = @a + 1
  @y0 = 1
  @h = 0.1
end

def f(x, y)
  if @var == 14
    return -y/x + y**2 / 3
  elsif @var == 19
    return -3/2.0 * Math.cos(x) * y + 2 * Math.exp(2*x)*(2+3*Math.cos(x))/y
  else
    return x**2 - 2 * y
  end
end

def f_exact(x)
  if @var == 14
    3/(x - x * Math.log(x))
  elsif @var == 19
    2 * Math.sqrt(Math.exp(2*x))
  else
    3 / 4.0 * Math.exp(-2 * x) + 1 / 2.0 * x**2 - 1 / 2.0 * x + 1 / 4.0
  end
end

def exact_solutions
  yn = []
  (@a..@a + 1).step(@h).each { |i| yn << f_exact(i.round(2)) }
  yn
end

def niter
  n = []
  (@a..@a1).step(@h).each { |i| n << i.round(2) }
  n
end

def euler(x0, y0)
  ans = [@y0]
  (@a...@a1).step(@h).each do |x0|
    y0 += @h * f(x0.round(2), y0)
    ans << y0
  end
  ans
end

def runge_kutta(x0, y0, h)
  ans = [y0]
  (@a...@a1).step(h).each do |x0|
    k1 = h * f(x0, y0)
    k2 = h * f((x0 + h / 2), (y0 + k1 / 2))
    k3 = h * f((x0 + h / 2), (y0 + k2 / 2))
    k4 = h * f((x0 + h), (y0 + k3))
    y0 += (k1 + 2 * k2 + 2 * k3 + k4) / 6
    ans << y0
  end
  ans
end

def cauchy(x0, y0, h)
  ans = [y0]
  (@a...@a1).step(@h).each do |x0|
    x0 = x0.round(2)
    k1 = h * f(x0, y0)
    k2 = h * f(x0 + (h/2), y0+(k1/2))
    y0 += k2
    ans << y0
  end
  ans
end

n = niter()
exact = exact_solutions
eul = euler(@a, @y0)
cau = cauchy(@a, @y0, @h)
rk = runge_kutta(@a, @y0, @h)
d_eul = []
d_cau = []
d_rk = []
eul_err = []
cau_err = []
rk_err = []

digits = 7
(0...n.length()).each do |i|
  d_eul << (eul[i] - exact[i]).abs.round(digits)
  d_cau << (cau[i] - exact[i]).abs.round(digits)
  d_rk << (rk[i] - exact[i]).abs.round(digits)
  eul_err << d_eul[i]/exact[i] 
  cau_err << d_cau[i]/exact[i]
  rk_err << d_rk[i]/exact[i]
  eul[i] = eul[i].round(digits)
  cau[i] = cau[i].round(digits)
  rk[i] = rk[i].round(digits)
  exact[i] = exact[i].round(digits)
end

def error(array, str)
  err = array.sum(0.0) / array.size
  puts "Eroarae pentru calcularea #{str} = #{(err * 100).round(5)}%"
end

labels_t = ["n", "Exact", "Euler","", "Cauchy","", "Runge kutta",""]
labels = ["n", "Exact", "Euler", "Cauchy", "Runge kutta"]
subheader = ['', '', "Yn", "|Y*n - Yn|", "Yn", "|Y*n - Yn|", "Yn", "|Y*n - Yn|"]

table = Text::Table.new
table.head = labels_t
table.rows = [subheader] + n.zip(exact, eul, d_eul, cau, d_cau, rk, d_rk)
table.to_s
puts table


error(eul_err, "Euler")
error(cau_err, "Cauchy")
error(rk_err, "RK")

plt = Matplotlib::Pyplot
plt.plot(n, exact, 'r', label=labels[1])
plt.plot(n, eul, 'b', label=labels[2])
plt.plot(n, cau, 'y', label=labels[3])
plt.plot(n, rk, 'k', label=labels[4])
plt.title('Graficul solutiilor')
plt.show()

csv = [labels] + n.zip(exact, eul, cau, rk)
File.write("plot_var#{@var}.csv", csv.map(&:to_csv).join)
csv = [labels_t, subheader] + n.zip(exact, eul, d_eul, cau, d_cau, rk, d_rk)
File.write("tab_var#{@var}.csv", csv.map(&:to_csv).join)
