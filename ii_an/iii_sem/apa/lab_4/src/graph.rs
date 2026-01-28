use rand::Rng;

#[allow(dead_code)]
pub fn dense(n: usize, max: usize) -> Vec<Vec<usize>>
{
    let mut graph = vec![vec![0; n]; n];
    let mut rng = rand::thread_rng();
    for i in 0..n {
        for j in 0..i{
            let num = rng.gen_range(0..=max);
            graph[i][j] = num;
            graph[j][i] = num;
        }
    }
    return graph;
}

#[allow(dead_code)]
pub fn rare(n: usize, max: usize) -> Vec<Vec<usize>>
{
    let connect = 2;
    let mut graph = vec![vec![0; n]; n];
    let mut rng = rand::thread_rng();
    for i in 0..n {
        for _j in 0..connect{
            let j = rng.gen_range(0..n);
            let num = rng.gen_range(0..=max);
            graph[i][j] = num;
            graph[j][i] = num;
        }
    }
    return graph;
}


#[allow(dead_code)]
pub fn valideaza(graph: &mut Vec<Vec<usize>>)
{
    // clear the diagonal
    for i in 0..graph.len() {
        graph[i][i] = 0;
    }

    let mut conex: Vec<usize> = vec![];
    for i in 0..graph.len() {
        for j in 0..=i {
            // mirrors the graph if it isn't ok
            if graph[i][j] != graph[j][i] {
                graph[j][i] = graph[i][j]
            }
            if graph[i][j] != 0 {
                if ! conex.contains(&i) && conex.len() == 0 {
                    conex.push(i);
                }
                if ! conex.contains(&i) && conex.contains(&j) {
                    conex.push(i);
                }
                if ! conex.contains(&j) && conex.len() == 0 {
                    conex.push(j);
                }
                if ! conex.contains(&j) && conex.contains(&i) {
                    conex.push(j);
                }
            }
        }
    }
    // connects the graph if it isn't conex
    if conex.len() != graph.len() {
        conex.sort();
        let mut rng = rand::thread_rng();
        for i in 0..graph.len(){
            if !conex.contains(&i) {
                    let num = rng.gen_range(0..=10);
                    let j = conex[rng.gen_range(0..conex.len())];
                    graph[i][j] = num;
                    graph[j][i] = num;
            }
        }

    }
}

