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

def recurenta(a, b, x)
  x1 = []
  (0...a.length).each do |i|
    line = b[i]
    a[i].each_with_index { |element, index| line -= element * x[index] if index != i }
    x1[i] = (1 / a[i][i].to_f) * line
  end
  x1
end

def solve_jacobi_conv_a(a)
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

def solve_jacobi_conv_b(a)
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

def solve_jacobi_conv_c(a)
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
  print "convergence a #{solve_jacobi_conv_a(a)}\n"
  print "convergence b #{solve_jacobi_conv_b(a)}\n"
  print "convergence c #{solve_jacobi_conv_c(a)}\n"
end

def error(k, x)
  err = 0
  x[k-1].each_with_index do |element , index|
    err = (element - x[k-2][index]).abs if err < (element - x[k-2][index]).abs or index == 0
  end
  err
end

def solve_jacobi(a, b, var)
  # test_convergence(a, var)
  k = 0
  x = [[0] * a.length]
  filename = "output_#{var}.csv"
  csv = csv_title(x, a.length)
  csv += "#{k}#{to_csv(x[k])}\n"
  err = 999
  while err > 10 ** -8 do
    x << (recurenta(a, b, x[k]))
    k += 1
    err = error(k, x)
    csv += "#{k}#{to_csv(x[k])},#{err.to_s if k > 1}\n"
  end
  File.open(filename, 'w') { |file| file.write(csv) }
end

def solve_gauss_seidel(a, b, var)
  k = 0
  x = [[0] * a.length]
  filename = "output_#{var}.csv"
  csv = csv_title(x, a.length)
  csv += "#{k}#{to_csv(x[k])}\n"
  order = dominance_order(a)
  err = 999
  x << recurenta(a, b, x[k])
  k += 1
  csv += "#{k}#{to_csv(x[k])}\n"
  while err > 10 ** -8 do
    x << (recurenta_gs(a, b, x[k], order))
    k += 1
    err = error(k, x)
    csv += "#{k}#{to_csv(x[k])},#{err.to_s if k > 1}\n"
  end
  File.open(filename, 'w') { |file| file.write(csv) }
end

def dominance_order(a)
  d = dominanti(a) 
  order = []
  (1..a.length).each do |i|
    order << d.index(d.max(i).last)
  end
  order
end

def recurenta_gs(a, b, x, order)
  xk = []
  order.each do |i|
    line = b[i]
    a[i].each_with_index do |e, j| 
      if j != i 
        if xk[j].nil? == false 
          this_x = xk[j] 
        else 
          this_x = x[j]
        end
        line -= e * this_x
      end
    end
    xk[i] = (1 / a[i][i].to_f) * line
  end
  xk
end

def print_matrix(mat)
  p 'Matrix'
  mat.each do |row|
    puts row.join('  ')
  end
  puts "\n"
end

def concatenate_b_to_a(a, b)
  c = []
  b.each_with_index do |e, i|
    c[i] = a[i].map(&:clone) << e
  end
  c
end

def perform_elimination(mat)
  (0...mat.size - 1).each do |step|
    (step...mat.size - 1).each do |i|
      a = (mat[i + 1][step] / mat[step][step].to_f)

      (step..mat.size).each do |j|
        mat[i + 1][j] = mat[i + 1][j] - (a * mat[step][j])
      end
    end
  end
  mat
end

def solve_gaussian(m1, m2)
  mat = concatenate_b_to_a(m1, m2)
  mat = perform_elimination(mat)
  (0...mat.size).to_a.reverse.each do |i|
    sum = 0
    (i + 1...mat.size).to_a.reverse.each do |j|
      mat[i][j] = mat[j][j] * mat[i][j]
      sum = mat[i][j] + sum
    end
    mat[i][i] = (mat[i][mat.size] - sum) / mat[i][i].to_f if mat[i][i] != 0
    p "x#{i} = #{mat[i][i]}"
  end
end


p 'Value of the Gaussian Elimination method'
solve_gaussian(a, b)
solve_gaussian(a14, b14)
solve_gaussian(a19, b19)

solve_jacobi(a, b, "ex_solve_jacobian")
solve_jacobi(a14, b14, "v14_solve_jacobian")
solve_jacobi(a19, b19, "v19_solve_jacobian")

solve_gauss_seidel(a, b, "ex_solve_gauss_seidel")
solve_gauss_seidel(a14, b14, "v14_solve_gauss_seidel")
solve_gauss_seidel(a19, b19, "v19_solve_gauss_seidel")
