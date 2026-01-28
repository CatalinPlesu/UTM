use std::cmp::Ordering;
#[allow(dead_code)]
fn comp_tree(a: &(usize, Vec<usize>), b: &(usize, Vec<usize>)) -> Ordering {
    if a.1[1] < b.1[1] {
        return Ordering::Less;
    } else if a.1[1] > b.1[1] {
        return Ordering::Greater;
    }
    return Ordering::Equal;
}

#[allow(dead_code)]
pub fn make_set(v: &usize, line: &Vec<usize>) -> Vec<(usize, Vec<usize>)>
{
    let mut tree = Vec::new();
    for i in 0..line.len()
    {
        if line[i] != 0 {
            tree.push((*v, vec![i, line[i]]));
        }
    }
    return tree;
}

#[allow(dead_code)]
fn union(u: &usize, v: &usize, sets: &mut Vec<Vec<usize>>)
{
    if *u == *v {
        return;
    }
    let mut a = sets[*v].clone();
    let mut b = sets[*u].clone();
    sets[*u].append(&mut a);
    sets[*v].append(&mut b);
    sets.remove(*v);
}

#[allow(dead_code)]
fn find_set(n: &usize, sets: &Vec<Vec<usize>>) -> usize
{
    for i in 0..sets.len() {
        if sets[i].contains(n) {
            return i;
        }
    }
    return 0usize;
}

#[allow(dead_code)]
pub fn minim(graph: &mut Vec<Vec<usize>>) -> usize
{   
    let n = graph.len();
    let mut A = vec![vec![0; n]; n];
    let mut V = Vec::new();
    for v in 0..n {
        V.append(&mut make_set(&v, &graph[v]));
    }
    V.sort_by(comp_tree);

    let mut sets = vec![vec![0; 1]; n];
    for i in 0..n {
        sets[i][0] = i;
    }

    for edge in &V {
        let u = edge.0;
        let v = edge.1[0];
        let tu = find_set(&u, &sets);
        let tv = find_set(&v, &sets); 
        if tu != tv {
            union(&tu, &tv, &mut sets);
            A[u][v] = edge.1[1];
            A[v][u] = edge.1[1];
        } 
        if sets[0].len() == n {
            break
        }
     }
    let mut cost = 0usize;
    for line in &A {
        for element in line {
            cost += element;
        }
    }
    *graph = A.clone();
    return cost / 2usize;
}
