#[allow(dead_code)]
pub fn log_2(n:usize) -> usize {
    // couldn't make long2 to work -___-
    let mut p: usize = 0;
    while 2usize.pow(p as u32) < n {
        p += 1 as usize;
    }
    p
}
