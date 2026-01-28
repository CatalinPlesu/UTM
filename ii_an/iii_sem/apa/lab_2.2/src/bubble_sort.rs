#[allow(dead_code)]
pub fn bubble_sort<T: Ord>(vec: &mut [T]) -> u128 {

    let mut comp :u128 = 0;
    for i in 0..vec.len() {
        let mut changes = false;
        for j in 0..vec.len() - 1 - i {
           comp += 1u128;
           if vec[j] > vec[j + 1] {
               vec.swap(j, j + 1);
               changes = true;
           } 
        }
        if !changes {break;}
    }
    comp
}

#[allow(dead_code)]
pub fn ascending<T: Ord>(vec: &mut [T]) -> u128 {
    let n = vec.len();
    println!("Array of {} elements bubble sort", n);
    bubble_sort(vec)
}
