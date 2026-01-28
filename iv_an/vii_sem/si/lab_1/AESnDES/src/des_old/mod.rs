use rand::Rng; 

pub mod tables;


pub fn generate_des_key() -> u64 {
    let mut rng = rand::thread_rng();

    let mut key: u64 = 0;

    // for each 8 byte of the key
    for byte_offset in 0..8 {
        let mut bit_count :u8 = 0;
        let mut byte :u8 = 0;
        // generate the 7 bits used by the key
        for bit in 0..7{
            let rnd_bit = rng.gen_range(0..=1); // Generate either 0 or 1
            byte |= rnd_bit << bit;
            bit_count += if rnd_bit == 1 { 1 } else { 0 };
        }
        byte |= if bit_count % 2 == 0 { 1 << 7 } else { 0 };
        key |= (byte as u64) << (byte_offset * 8);
    }

    key
}

pub fn validate_des_key(key: u64) -> bool {
    let mut valid = true;
    for byte in (0..8).rev() {
        let mut bit_count :u8 = 0;
        for  bit in (0..8).rev()
        {
            let this_bit = ((key >> (byte * 8 + bit)) & 0x01) as u8;
            bit_count += if this_bit == 1 { 1 } else { 0 };
        }
        if (bit_count as u64 + ( key >> (byte * 8 + 7) & 0x01) % 2) == 0 {
            valid = false;
        }
    }
    valid
}


pub fn permutation<const N: usize>(input_block: u64, permutation_table: &[u8; N]) -> u64 {
    // Initialize the result as 0
    let mut result: u64 = 0;

    // Perform the permutation using the provided table
    for i in 0..N {
        result <<= 1;
        result |= (input_block >> (64 - permutation_table[i])) & 1;
    }
    return result;
}

pub fn extract_left_part<const N: usize>(key: u64) -> u32 {
    // Right-shift the key by 28 bits and mask to get the left part
    let mask: u32 = ((1u64 << N) - 1) as u32;
    (key >> N) as u32 & mask
}

pub fn extract_right_part<const N: usize>(key: u64) -> u32 {
    // Mask the key to get the right part
    let mask: u32 = ((1u64 << N) - 1) as u32;
    key as u32 & mask
}

pub fn left_rotate<const N: usize>(value: u32, n: u8) -> u32 {

    // Perform the left rotation
    let rotated_value = (value << n) | (value >> (N - n as usize));

    rotated_value
}

pub fn connect<const N: usize>(l: u32, r: u32) -> u64 {
    ( (l as u64) << N ) | (r as u64)
}

pub fn generate_subkeys(key: u64)  -> [u64; 16] {
    let mut subkeys: [u64; 16] = [0; 16];
    let mut c = extract_left_part::<28>(key);
    let mut d = extract_right_part::<28>(key);

    for i in 0..16 {
        c = left_rotate::<28>(c, tables::SHIFTS[i]);
        d = left_rotate::<28>(d, tables::SHIFTS[i]);
        subkeys[i] = permutation::<48>(connect::<28>(c, d), &tables::PC2);
    }

    subkeys
}

pub fn encrypt(data: u64, key: u64) -> Result<u64, bool> {

    //validate key
    if !validate_des_key(key) { 
        return Err(false);
    }

    //pc-1 permutation for key
    let key = permutation::<56>(key, &tables::PC1);

    let subkeys = generate_subkeys(key);

    des(data, key, &subkeys)
}

pub fn decrypt(ciphertext: u64, key: u64) -> Result<u64, bool> {
    // Validate key
    if !validate_des_key(key) { 
        return Err(false);
    }

    // PC-1 permutation for key
    let key = permutation::<56>(key, &tables::PC1);

    // Generate subkeys
    let mut subkeys = generate_subkeys(key);

    // Reverse subkeys order
    let len = subkeys.len();
    let mid = len / 2;
    for i in 0..mid {
        let j = len - 1 - i;
        subkeys.swap(i, j);
    }

    des(ciphertext, key, &subkeys)
}

fn des(data: u64, key: u64, subkeys: &[u64; 16]) -> Result<u64, bool> {
    let mut data = permutation::<64>(data, &tables::IP);

    let mut l =  extract_left_part::<32>(data);
    let mut r = extract_right_part::<32>(data);
    let mut lr = l;

    for i in 0..16 {
        // Expand right part
        let e = permutation::<48>(r as u64, &tables::E);
        let xor = e ^ subkeys[i];

        // Substitution boxes
        r = 0;
        for b in 0..8 {
            let bn = (xor >> (b * 6)) & 0x3F;
            r |= (tables::SBOXES[b][bn as usize] as u32) << (b * 4);
        }

        r = permutation::<32>(r as u64, &tables::P) as u32;
        r ^= l;
        l = lr;
        lr = r;
    }

    data = connect::<32>(l, r);

    Ok(permutation::<64>(data, &tables::IP1))
}