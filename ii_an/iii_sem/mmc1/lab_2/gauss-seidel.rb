def recurenta(a, b, x, d)
  (1..a.length).each do |i|
    index = d.index(d.max(i).last)
    puts index
  end
end

def gauss_matrix(a, b)
  c = []
  b.each_with_index do |e, i|
    c[i] = a[i].map(&:clone) << e
  end
  c
end
