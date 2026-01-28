# Python3 program to print 1's and 2's
# complement of a binary number
 
# Returns '0' for '1' and '1' for '0'
def flip(c):
    return '1' if (c == '0') else '0'
 
# Print 1's and 2's complement of
# binary number represented by "bin"
def printOneAndTwosComplement(bin):
 
    n = len(bin)
    ones = ""
    twos = ""
     
    # for ones complement flip every bit
    for i in range(n):
        ones += flip(bin[i])
 
    # for two's complement go from right
    # to left in ones complement and if
    # we get 1 make, we make them 0 and
    # keep going left when we get first
    # 0, make that 1 and go out of loop
    ones = list(ones.strip(""))
    twos = list(ones)
    for i in range(n - 1, -1, -1):
     
        if (ones[i] == '1'):
            twos[i] = '0'
        else:        
            twos[i] = '1'
            break
 
    i -= 1   
    # If No break : all are 1 as in 111 or 11111
    # in such case, add extra 1 at beginning
    if (i == -1):
        twos.insert(0, '1')
 
    print("1's complement: ", *ones, sep = "")
    print("2's complement: ", *twos, sep = "")

def num_to_bin(n):
    negative = False
    if n < 0:
        negative = True
        n *= -1
    str = bin(n)
    str = str[2:len(str)]
    print('{} to bin = {}'.format(n, str))
    if negative:
        print("1 before + addition")
    else:
        print("0 before")
    printOneAndTwosComplement(str.strip(""))

if __name__ == '__main__':
    num_to_bin(4)
    num_to_bin(-4)
