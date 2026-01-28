#include <stdio.h>
#include <stdlib.h>  // For random number generation
#include <time.h>    // For seeding the random number generator
#include <math.h>
#include <stdint.h>

#define PRIME_CNT 3
// const int primes[PRIME_CNT] = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463,467, 479, 487, 491, 499 };
const int primes[PRIME_CNT] = { 2, 3, 5};

typedef uint64_t u64;

u64 gcd(u64 a, u64 b);
u64 encrypt(u64 value, u64 e, u64 n);
u64 decrypt(u64 value, u64 d, u64 n);
u64 modExp(u64 base, u64 exponent, u64 modulus);

int main() {
    // Seed the random number generator
    srand(time(NULL));


    // Choose p and q
    u64 p = primes[rand() % PRIME_CNT];
    u64 q = primes[rand() % PRIME_CNT];
    printf("P is %ld\n", p);
    printf("Q is %ld\n", q);

    // Compute n = p * q 
    u64 n = p * q;
    printf("n = %ld\n", n);

    // Compute φ(n) = (p - 1) * (q - 1)
    u64 fi = (p - 1) * (q - 1);
    printf("fi = %ld\n", fi);

    // Choose e such that 1 < e < φ(n) and e and φ (n) are coprime.
    u64 e = 2;
    while (e < fi) {
        if (gcd(e, fi) == 1)
            break;
        else
            e++;
    }
    printf("e = %ld\n", e);

    // Compute a value for d such that (d * e) % φ(n) = 1.
    u64 d = e % fi;
    u64 x = 1;
	for (x = 1; x < fi; x++) {
		if ((d * x) % fi == 1) 
            break;
	}
    d = x;
    printf("d = %ld\n", d);

    // Public key is (e, n)
    // Private key is (d, n)
    u64 data = 20;
    printf("data %ld\n", data);

    // The encryption of m; c = m ^ e % n
    data = encrypt(data, e, n);
    
    printf("encrypted %ld\n", data);

    // The decryption of c; m = c ^ d % n
    data = decrypt(data, d, n);
    printf("decrypted %ld\n", data);

    return 0;
}

u64 gcd(u64 a, u64 b) {
    while (b != 0) {
        u64 temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}


u64 encrypt(u64 value, u64 e, u64 n)
{
    // The encryption of m; c = m ^ e % n
    return (u64)(powf(value, e)) % n;
    //return modExp(value, e, n);
}

u64 decrypt(u64 value, u64 d, u64 n)
{
    // The decryption of c; m = c ^ d % n
    return (u64)(powf(value, d)) % n;
    //return modExp(value, d, n);
}

// Function to perform modular exponentiation (a^b % mod)
u64 modExp(u64 base, u64 exponent, u64 modulus) {
    u64 result = 1;
    while (exponent > 0) {
        if (exponent % 2 == 1) {
            result = (result * base) % modulus;
        }
        base = (base * base) % modulus;
        exponent /= 2;
    }
    return result;
}