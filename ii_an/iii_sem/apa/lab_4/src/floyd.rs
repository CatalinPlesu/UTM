#[allow(dead_code)]
pub fn run(graph: &Vec<Vec<usize>>) -> Vec<Vec<usize>>
{
    let n = graph.len();

    let mut D = graph.clone();
    for i in 0..n {
        for j in 0..n {
            if i != j && D[i][j] == 0 {
                D[i][j] = std::usize::MAX/2;
            }
        }
    }

    for k in 0..n {
        for i in 0..n {
            for j in 0..n {
                // D[i][j] = std::cmp::min(D[i][j], D[i][k] + D[k][j]);
                if D[i][k] + D[k][j] < D[i][j] {
                    D[i][j] = D[i][k] + D[k][j];
                }
            }
        }
    }
    return D;
}

#[allow(dead_code)]
pub fn get_path(s: usize, d: usize, graph: &Vec<Vec<usize>>, floyd: &Vec<Vec<usize>>)
{
    let mut path = vec![s];
    let n = graph.len();
    while path[path.len()-1] != d {
        let current = path[path.len()-1];
        let mut optim = s;
        for i in 0..n {
            if graph[current][i] != 0 {
                if floyd[current][d] as i32 - floyd[current][i] as i32 == floyd[i][d] as i32 && 
                    floyd[i][d] <=floyd[optim][d] {
                    optim = i;
                }
            }
        }
        path.push(optim);
    }
    println!("cost({}, {}) = {}", s, d, floyd[s][d]);
    println!("path({}, {}) = {:?}", s, d, path);
}

pub fn print_paths(s: &usize, graph: &Vec<Vec<usize>>, floyd: &Vec<Vec<usize>>)
{
    for i in 0..graph.len() {
        if i != *s {
            get_path(*s, i, graph, floyd); 
        }
    }
}
