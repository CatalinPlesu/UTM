#[allow(dead_code)]
 fn min_cost(cost: &Vec<usize>, visited: &Vec<bool>) -> usize
 {
     let mut min = std::usize::MAX;
     let mut min_index = 0usize;

     for v in 0..cost.len() {
         if visited[v] == false && cost[v] <= min {
             min = cost[v];
             min_index = v;
         }
     }
 
     return min_index;
 }
 
#[allow(dead_code)]
pub fn run(s: usize, graph: &Vec<Vec<usize>>) -> (Vec<usize>, Vec<usize>)
 {
     let n = graph.len();
     let mut cost = vec![std::usize::MAX; n];
     let mut path = vec![0; n];
     let mut visited = vec![false; n]; 

     cost[s] = 0;
     for count in 0..n-1 {
         let u = min_cost(&cost, &visited);
         visited[u] = true;
         for v in 0..n {
             if !visited[v] && graph[u][v] != 0 && cost[u] != std::usize::MAX 
                 && cost[u] + graph[u][v] < cost[v] {
                     cost[v] = cost[u] + graph[u][v];
                     path[v] = u;
                 }
         }
     }
     return (path, cost);
 }

// #[allow(dead_code)]
pub fn print_path(s: usize, path: Vec<usize>, cost: Vec<usize>)
{
    for i in 0..path.len() {
        if i != s {
            println!("cost({}, {}) = {}", s, i, cost[i]);
            let mut ord = vec![i];
            while ord[ord.len()-1] != s {
                ord.push(path[ord[ord.len()-1]]);
            }
            ord.reverse();
            println!("path({}, {}) = {:?}", s, i, ord);
        }
    }
}
