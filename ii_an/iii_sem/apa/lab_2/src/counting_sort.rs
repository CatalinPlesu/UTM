#[allow(dead_code)]
pub fn counting_sort(vec: &mut [i32]) -> u128{

    let mut comp: u128 = 0;
    let (mut min,mut max): (i32, i32) = (std::i32::MAX, std::i32::MIN);

    for x in &mut *vec {
        if *x >= max { max = *x;}
        if *x <= min { min = *x;}
    }

    let mut neg_vec = vec![0; i32::abs(min) as usize + 1usize];
    let mut pos_vec = vec![0; i32::abs(max) as usize + 1usize];

    for x in &mut *vec {
        if *x < 0 {
           neg_vec[i32::abs(*x) as usize] += 1;
        } else {
           pos_vec[i32::abs(*x) as usize] += 1;
        }
    }

    let mut z: usize = 0usize;
    for i in (0..neg_vec.len()).rev() {
        comp += 1u128;
        while neg_vec[i] > 0 {
            comp += 1u128;
            neg_vec[i] -= 1;
            vec[z] = -(i as i32);
            z += 1usize;
        }
    }
    for i in 0..pos_vec.len() {
        comp += 1u128;
        while pos_vec[i] > 0 {
            comp += 1u128;
            pos_vec[i] -= 1;
            vec[z] = i as i32;
            z += 1usize;
        }
    }
    comp
}

#[allow(dead_code)]
pub fn ascending(vec: &mut [i32]) -> u128 {
    let n = vec.len();
    println!("Array of {} elements counting sort", n);
    counting_sort(vec)
}
