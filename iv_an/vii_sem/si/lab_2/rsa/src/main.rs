extern crate num_bigint;
extern crate rand;

use num_bigint::{BigUint, ToBigUint, RandomBits};
use rand::{thread_rng, Rng};
use num_traits::identities::{One, Zero};
use rand::distributions::Uniform;

fn main() {
    // Generate RSA keys
    let (public_key, private_key) = generate_rsa_keys(1024);

    // Message to encrypt
    let message = "Hello, RSA!";
    let message_bytes = message.as_bytes();

    // Encrypt the message using the public key
    let encrypted = encrypt(message_bytes, &public_key);

    // Decrypt the message using the private key
    let decrypted = decrypt(&encrypted, &private_key);

    // Convert the decrypted bytes back to a string
    let decrypted_message = String::from_utf8(decrypted).expect("Invalid UTF-8");

    println!("Original Message: {}", message);
    println!("Decrypted Message: {}", decrypted_message);
}

// Define a struct to represent RSA keys
#[derive(Debug)]
struct RSAKey {
    n: BigUint,
    e: BigUint, // Public exponent
    d: BigUint, // Private exponent
}

// Generate RSA keys
fn generate_rsa_keys(bits: usize) -> (RSAKey, RSAKey) {
    // Generate two large prime numbers, p and q
    let p = generate_large_prime(bits / 2);
    let q = generate_large_prime(bits / 2);

    // Calculate n = p * q
    let n = &p * &q;

    // Calculate the totient of n: phi(n) = (p - 1) * (q - 1)
    let phi_n = (&p - BigUint::one()) * (&q - BigUint::one());

    // Choose a public exponent e (usually 65537)
    let e = 65537.to_biguint().unwrap();

    // Calculate the private exponent d: d ≡ e^(-1) mod phi(n)
    let d = mod_inverse(&e, &phi_n);

    // Create the public and private keys
    let public_key = RSAKey {
        n: n.clone(),
        e: e.clone(),
        d: BigUint::zero(),
    };
    let private_key = RSAKey { n, e, d };

    (public_key, private_key)
}

// Generate a large prime number
fn generate_large_prime(bits: usize) -> BigUint {
    let mut rng = thread_rng();
    loop {
        let candidate: BigUint = rng.sample(RandomBits::new(64));
        if is_prime(&candidate) {
            return candidate;
        }
    }
}

// Check if a number is prime using the Miller-Rabin primality test
fn is_prime(n: &BigUint) -> bool {
    if n / 2u64 ==  BigUint::zero()  {
        return false;
    }

    let mut rng = thread_rng();
    let k = 5; // Number of iterations for the Miller-Rabin test

    for _ in 0..k {
        let a: BigUint = rng.sample(Uniform::from( BigUint::from(2u64)..n.clone()));

        if !miller_rabin_test(n, &a) {
            return false;
        }
    }

    true
}

// Miller-Rabin primality test
fn miller_rabin_test(n: &BigUint, a: &BigUint) -> bool {
    let mut d = n - BigUint::one();
    let mut s = 0;

    while n / 2u64 == BigUint::zero() {
        d >>= 1;
        s += 1;
    }

    let mut x = a.modpow(&d, n);

    if x.is_one() || x == n - BigUint::one() {
        return true;
    }

    for _ in 0..s - 1 {
        x = x.modpow(&BigUint::from(2u64), n);
        if x == n - BigUint::one() {
            return true;
        }
    }

    false
}

// Calculate the modular inverse of a number
fn mod_inverse(a: &BigUint, m: &BigUint) -> BigUint {
    let mut x0 = BigUint::zero();
    let mut x1 = BigUint::one();
    let mut a = a.clone();
    let mut m = m.clone();

    while a > BigUint::one() {
        let q = &a / &m;
        let tmp = m.clone();
        m = a % &m;
        a = tmp;

        let tmp = x0.clone();
        x0 = x1 - q * x0;
        x1 = tmp;
    }

    if x1 < BigUint::zero() {
        x1 += m.clone(); // Use `m` instead of `m0`
    }

    x1
}

// Encrypt a message using the public key
fn encrypt(message: &[u8], public_key: &RSAKey) -> Vec<BigUint> {
    let mut encrypted = Vec::new();
    for chunk in message.chunks((public_key.n.bits() - 1) as usize) {
        let m = BigUint::from_bytes_be(chunk);
        let c = m.modpow(&public_key.e, &public_key.n);
        encrypted.push(c);
    }
    encrypted
}

// Decrypt a message using the private key
fn decrypt(encrypted: &[BigUint], private_key: &RSAKey) -> Vec<u8> {
    let mut decrypted = Vec::new();
    for c in encrypted {
        let m = c.modpow(&private_key.d, &private_key.n);
        let chunk = m.to_bytes_be();
        decrypted.extend_from_slice(&chunk);
    }
    decrypted
}
