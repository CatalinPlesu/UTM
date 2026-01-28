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
    numitor = 0
    numarator = 0
    row.each_with_index do |element, c_index|
      if c_index == r_index
        numarator = element
      else
        numitor += element.abs
      end
    end
    dom.append(numarator/numitor.to_f)
  end
    dom
end


# pasul 2: reucrenta...
def recurenta(a, b, x)
  x1 = []
  (0...a.length).each do |i|
    line = b[i]
    a[i].each_with_index do |element, index|
      if index != i
        line -= element * x[index] 
      end
    end
    x1[i] = (1/a[i][i].to_f) * line
  end
  x1
end

def to_csv(x)
  string = ""
  x.each do |e|
    string += "," + e.to_s
  end
  string
end

def csv_title(x, n)
  line = "iteratia"
  (1..n).each do |x|
    line += ",x" + x.to_s
  end
  line += ",eroarea\n"
end

def csv_solutia_exacta(x)
  line = "solutia exacta"
  x.each do |e|
    line += ",#{e.round}"
  end
  line += ",-\n"
  line
end


def jacobi(a, b, var)
  k = 0
  x = [[0] * a.length]
  filename = "output_#{var}.csv"
  csv = csv_title(x, a.length)
  csv += "#{k}" + to_csv(x[k]) + "\n"
  # File.open(filename, 'w') { |file| file.write(csv_title(x, a.length)) }
  # File.open(filename, 'a') { |file| file.write("#{k}" + to_csv(x[k]) + "\n") }
  err = 999
  while err > 10 ** -3 do
    x.append(recurenta(a, b, x[k]))
    k += 1
    if k > 1
      x[k-1].each_with_index do |element , index|
        err = (element - x[k-2][index]).abs if err < (element - x[k-2][index]).abs or index == 0
      end
    end
    # File.open(filename, 'a') { |file| file.write("#{k}" + to_csv(x[k]) + "," + err.to_s + "\n") }
    csv += "#{k}" + to_csv(x[k]) + "," + err.to_s + "\n"
  end
    # File.open(filename, 'a') { |file| file.write(csv_solutia_exacta(x[k])) }
  File.open(filename, 'w') { |file| file.write(csv) }
end

jacobi(a, b, "exemplu")
jacobi(a14, b14, "14")
jacobi(a14, b19, "19")
