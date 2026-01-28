require 'matrix'

x = [-1.104, -0.986, 0.465, 1.235, 2.476, 3.789, 4.987]
y = [4.13567, 2.29876, 0.01238, -2.4587, -1.1154, 0.56478, 2.17854]


def regress x, y, degree
  x_data = x.map { |xi| (0..degree).map { |pow| (xi**pow).to_r } }

  mx = Matrix[*x_data]
  my = Matrix.column_vector(y)

  ((mx.t * mx).inv * mx.t * my).transpose.to_a[0].map(&:to_f)
end


def print_points(x, y)
  for x,y in x.zip(y)
        puts("(#{x}, #{y})")
    end
end

def print_function(v)
  (0...v.length()).to_a.reverse.each do |i|
    print "#{v[i]} * x^#{i} #{"+ " if i!=0}"
  end
end

vars = regress(x, y, x.length()-1)
print_points(x, y)
print_function(vars)
