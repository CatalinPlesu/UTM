use std::io::Write;
use std::process::Command;
use colored::*;
use std::time::Instant;
mod graph;
mod dijkstar;
mod floyd;

#[allow(dead_code)]
fn export_graph(graph: &Vec<Vec<usize>>)
{
    let mut file = std::fs::File::create("graph.csv").expect("create failed");
    let csv = csv_graph(graph);
    file.write_all(csv.as_bytes()).expect("write failed");
}

#[allow(dead_code)]
fn csv_graph(graph: &Vec<Vec<usize>>) -> String
{
    let mut csv = String::new();
    for line in graph {
        for i in 0..line.len() {
            if i == 0 {
                csv = format!("{}{}", csv, line[i]);
            } else {
                csv = format!("{},{}", csv, line[i]);
            }
        }
        csv = format!("{}\n", csv);
    }
    return csv;
}

#[allow(dead_code)]
fn plot_graph()
{
    Command::new("python")
            .arg("src/main.py")
            .spawn()
            .expect("sh command failed to start");
}

fn print_g(g: &Vec<Vec<usize>>)
{
    for line in g{
        println!("{:?}", line);
    }
}

fn logic_errors_test()
{
    println!("Matricea de adiacenta:");
    let mut graph = vec![
        vec![0, 4, 3, 0, 0, 0],
        vec![4, 0, 1, 2, 0, 0],
        vec![3, 1, 0, 4, 0, 0],
        vec![0, 2, 4, 0, 2, 0],
        vec![0, 0, 0, 2, 0, 6],
        vec![0, 0, 0, 0, 6, 0]];
    export_graph(&graph);
    plot_graph();
    print_g(&graph);

    let dijkstar = dijkstar::run(0, &graph);
    println!();
    println!("In urma aplicarii algoritmului dijkstar obtinem:");
    println!("Cost = {:?}", dijkstar.1); 
    println!("Calea = {:?}", dijkstar.0); 
    dijkstar::print_path(0, dijkstar.0, dijkstar.1);

    let floyd = floyd::run(&graph);
    println!();
    println!("In urma aplicarii algoritmului floyd obtinem:");
    print_g(&floyd);
    floyd::print_paths(&0, &graph, &floyd);
}

fn performance_test(n: usize){
    let weight = 150000;
    println!("Comparing {} and {}",
             "Dijkstar".bold().blue(),
             "Floyd".bold().green());
    println!("Number of edges = {} and max weight = {}",
             n.to_string().bold().red(),
             weight.to_string().bold().yellow());

    let mut graph = graph::rare(n, weight);
    graph::valideaza(&mut graph);
    
    // println!("Executing {} algorithm un singur drum",
    //          "Dijkstar".bold().green());
    //     let time = Instant::now();
    //         let dijkstar = dijkstar::run(1, &graph);
    //     let end = time.elapsed().as_secs();
    // println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());

    println!("Executing {} algorithm toate drumurile",
             "Dijkstar".bold().green());
    let time = Instant::now();
        for i in 0..n {
            let dijkstar = dijkstar::run(1, &graph);
        }
    let end = time.elapsed().as_secs();
    println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());

    println!("Executing {} algorithm",
             "Floyd".bold().blue());
        let time = Instant::now();
            let floyd = floyd::run(&graph);
        let end = time.elapsed().as_secs();
    println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());
}

#[warn(dead_code)]
fn main() {
    println!("works ^-^");

    // logic_errors_test();

    for i in 1..=5 {
        performance_test(i * 1000);
    }
        // performance_test(1000);
}
