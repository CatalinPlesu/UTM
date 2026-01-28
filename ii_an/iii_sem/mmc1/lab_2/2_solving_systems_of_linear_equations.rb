# frozen_string_literal: true
require 'rubocop'

# mat = [[1, 1, 1, 6],
#        [1, -1, 2, 5],
#        [2, -1, -1, -3]]

# mat = [[16.8, 0.9, 1.2, 1.4, 21.3],
#        [0.9, 21.1, 0.9, 0.8, 11.4],
#        [1.2, 0.9, 17.3, -0.4, -17.9],
#        [1.4, 0.8, -0.4, 15.9, 20.6]]
mat = [[16, -2, 3, 24],
       [3, 8, 1, -3],
       [1, -1, 5, 12]] 

p 'Matrix'
mat.each do |row|
  puts row.join('  ')
end
puts "\n"

def perform_elimination(mat)
  (0...mat.size - 1).each do |step|
    (step...mat.size - 1).each do |i|
      a = (mat[i + 1][step] / mat[step][step])

      (step..mat.size).each do |j|
        mat[i + 1][j] = mat[i + 1][j] - (a * mat[step][j])
      end
    end
  end
  mat
end

def solve_gaussiann_method(mat)
  mat = perform_elimination(mat)
  (0...mat.size).to_a.reverse.each do |i|
    sum = 0
    (i + 1...mat.size).to_a.reverse.each do |j|
      mat[i][j] = mat[j][j] * mat[i][j]
      sum = mat[i][j] + sum
    end
    mat[i][i] = (mat[i][mat.size] - sum)/ mat[i][i] if mat[i][i] != 0
    p "x#{i} = #{mat[i][i]}"
  end
end

p 'Value of the Gaussian Elimination method'
solve_gaussiann_method(mat)
