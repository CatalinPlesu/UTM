fn min_key(key: &Vec<usize>,mst_set: &Vec<bool>) -> usize
{
    let mut min = std::usize::MAX;
    let mut min_index: usize = 0;
 
    for v in 0..key.len() {
        if mst_set[v] == false && key[v] < min {
            min = key[v];
            min_index = v;
        }
    }
 
    return min_index;
}
 
 
pub fn minim(r: &usize, graph: &mut Vec<Vec<usize>>) -> usize
{
    let n = graph.len();
    let mut parent = vec![-2i32; n];
    let mut key = vec![0; n];
    let mut mst_set = vec![false; n];
    for i in 0..n {
        key[i] = std::usize::MAX;
    }

    key[*r] = 0usize;
    parent[*r] = -1;
 
    for _count in 0..n-1
    {
        let u = min_key(&key, &mst_set);
 
        mst_set[u] = true;
 
        for v in 0..n {
            if graph[u][v] != 0 && mst_set[v] == false && graph[u][v] < key[v] {
                parent[v] = u as i32;
                key[v] = graph[u][v];
            }
        }
    }
    let mut cost = 0usize;
    let mut A = vec![vec![0; n]; n];
    for i in 0..n {
        if parent[i] >= 0 {
            let v = parent[i] as usize;
            A[i][v] = graph[i][v];
            A[v][i] = graph[i][v];
            cost += graph[i][v];
        }
    }
    *graph = A.clone();
    return cost;
}
