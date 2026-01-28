#!/bin/ruby
# frozen_string_literal: true

# 14
a14 = [[10.2, 1.7, -0.8, 0.4],
       [1.7, 12.6, 1.2, 0.3],
       [-0.8, 1.2, 11.7, -1.2],
       [0.4, 0.3, -1.2, 20.6]]
b14 = [12.6, 13.9, -4.7, 20.6]

# 19
a19 = [[16.8, 0.9, 1.2, 1.4],
       [0.9, 21.1, 0.9, 0.8],
       [1.2, 0.9, 17.3, -0.4],
       [1.4, 0.8, -0.4, 15.9]]
b19 = [21.3, 11.4, -17.9, 20.6]

# exemplu pdf
a = [[16, -2, 3],
     [3, 8, 1],
     [1, -1, 5]]
b = [24, -3, 12]

def dominanti(m)
  dom = []
  m.each_with_index do |row, r_index|
    denominator = 0
    numerator = 0
    row.each_with_index do |element, c_index|
      c_index == r_index ? numerator = element : denominator += element.abs
    end
    dom << (numerator / denominator.to_f)
  end
  dom
end

# pasul 2: reucrenta...
def recurenta(a, b, x)
  x1 = []
  (0...a.length).each do |i|
    line = b[i]
    a[i].each_with_index { |element, index| line -= element * x[index] if index != i }
    x1[i] = (1 / a[i][i].to_f) * line
  end
  x1
end

def to_csv(x)
  string = ''
  x.each { |e| string += ",#{e}" }
  string
end

def csv_title(x, n)
  line = 'iteratia'
  (1..n).each do |x|
    line += ",x" + x.to_s
  end
  line += ",eroarea\n"
end

def jacobi_conv_a(a)
  aij = 0
  aii = 0
  a.each_with_index do |r, i|
    r.each_with_index do |e, j|
      if j != i
        aij += a[i][j].abs
        aii += a[i][i].abs
      end
    end
  end
  aij < aii
end

def jacobi_conv_b(a)
  aij = 0
  ajj = 0
  a.each_with_index do |r, i|
    r.each_with_index do |e, j|
      if j != i
        aij += a[i][j].abs
        ajj += a[j][j].abs
      end
    end
  end
  aij < ajj
end

def jacobi_conv_c(a)
  sa = 0
  a.each_with_index do |r, i|
    r.each_with_index do |e, j|
      if j != i
        sa += (a[i][j] / a[i][i]) ** 2
      end
    end
  end
  sa < 1
end

def test_convergence(a, var)
  print "varianta #{var}\n"
  print "jacobi converge a #{jacobi_conv_a(a)}\n"
  print "jacobi converge b #{jacobi_conv_b(a)}\n"
  print "jacobi converge c #{jacobi_conv_c(a)}\n"
end

def jacobi(a, b, var)
  test_convergence(a, var)
  k = 0
  x = [[0] * a.length]
  filename = "output_#{var}.csv"
  csv = csv_title(x, a.length)
  csv += "#{k}" + to_csv(x[k]) + "\n"
  err = 999
  while err > 10 ** -8 do
    x << (recurenta(a, b, x[k]))
    k += 1
    if k > 1
      x[k-1].each_with_index do |element , index|
        err = (element - x[k-2][index]).abs if err < (element - x[k-2][index]).abs or index == 0
      end
    end
    csv += "#{k}" + to_csv(x[k]) + "," + err.to_s + "\n"
  end
  File.open(filename, 'w') { |file| file.write(csv) }
end

jacobi(a, b, 'example')
jacobi(a14, b14, '14')
jacobi(a14, b19, '19')
