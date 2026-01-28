use std::io::Write;
use std::process::Command;
use colored::*;
use std::time::Instant;
#[macro_use]
extern crate text_io;
mod graph;
mod kruskal;
mod prim;

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

#[allow(dead_code)]
fn main_test()
{
    println!("{}", "Testing Algorithm Performance".to_string().bold().blue().on_color("yellow"));
    // let n = [100, 250, 500, 1000];
    // let n = [2000, 5000, 10000, 20000];
    let n = [25000, 30000, 35000];
    let weight = 10000usize;

    for i in n {

    let mut graph_k = graph::rare(i, weight);
    graph::valideaza(&mut graph_k);
    let mut graph_p = graph_k.clone();

    println!("{} {} nodes", "Testing time for Kruskal MST rare graph".bold().blue(), i.to_string().bold().green());
        let time = Instant::now();
            kruskal::minim(&mut graph_k);
        let end = time.elapsed().as_millis();
        // let end = time.elapsed().as_secs();
    println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());

    println!("{} {} nodes", "Testing time for Prim MST rare graph".bold().blue(), i.to_string().bold().green());
        let time = Instant::now();
            prim::minim(&1usize, &mut graph_p);
        let end = time.elapsed().as_millis();
        // let end = time.elapsed().as_secs();
    println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());


    // let mut graph_k = graph::dense(i, weight);
    // graph::valideaza(&mut graph_k);
    // let mut graph_p = graph_k.clone();

    // println!("{} {} nodes", "Testing time for Kruskal MST dense graph".bold().blue(), i.to_string().bold().green());
    //     let time = Instant::now();
    //         kruskal::minim(&mut graph_k);
    //     // let end = time.elapsed().as_millis();
    //     let end = time.elapsed().as_secs();
    // println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());

    // println!("{} {} nodes", "Testing time for Prim MST dense graph".bold().blue(), i.to_string().bold().green());
    //     let time = Instant::now();
    //         prim::minim(&1usize, &mut graph_p);
    //     // let end = time.elapsed().as_millis();
    //     let end = time.elapsed().as_secs();
    // println!("{} {}", "Executed in".bold().yellow(), end.to_string().bold().red());

    }

}


#[allow(dead_code)]
fn menu()
{
    println!("{}", "Menu APA lab nr. 3:".to_string().bold().yellow().on_color("blue"));
    println!("{}", "0. quit".to_string().red());
    println!("{}", "10. Set graph size".to_string().yellow());
    println!("{}", "11. Generate rare graph".to_string().blue());
    println!("{}", "12. Generate dense graph".to_string().green());
    println!("{}", "13. Restore graph".to_string().cyan());
    println!("{}", "##########################".to_string().bold().truecolor(150, 161, 112));
    println!("{}", "21. Print adjacency matrix".to_string().magenta());
    println!("{}", "22. Plot the graph".to_string().bold().truecolor(0, 255, 136));
    println!("{}", "##########################".to_string().bold().truecolor(150, 161, 112));
    println!("{}", "31. Spanning tree Kruskal".to_string().blue());
    println!("{}", "32. Spanning tree Prim".to_string().green());
    println!("{}", "##########################".to_string().bold().truecolor(150, 161, 112));
    println!("{}", "4. RUN TESTS".to_string().bold().truecolor(242, 145, 27));
}

#[warn(dead_code)]
fn main() {
    println!("works ^-^");
    let weight = 15;
    let mut graph = vec![
        vec![0, 0, 0, 0, 0],
        vec![1, 0, 0, 0, 0],
        vec![3, 2, 0, 0, 0],
        vec![0, 0, 3, 0, 0],
        vec![7, 0, 3, 2, 0]];
    let mut size: usize = graph.len();
    graph::valideaza(&mut graph);
    let mut graph_back = graph.clone();

    let mut m = 1;
    menu();
    while m != 0 {
        println!("{}", "-1. help menu".to_string().bold().blue());
        println!("\nInteger expected: ");
        m = read!();
        match m {
            -1 => menu(),
            10 => {
                println!("New graph size: ");
                size = read!();
                println!("{} {}", "New graph size set to".to_string().green(),
                         size);
            },
            11 => {
                graph = graph::rare(size, weight);
                graph::valideaza(&mut graph);
                graph_back = graph.clone();
                println!("{}", "Rare graph generated successfully".to_string().green());
            },
            12 => {
                graph = graph::dense(size, weight);
                graph::valideaza(&mut graph);
                graph_back = graph.clone();
                println!("{}", "Dense graph generated successfully".to_string().green());
            },
            13 => {
                graph = graph_back.clone();
                println!("{}", "Graph restored successfully".to_string().green());
            },
            21 => {
                for line in graph.clone() {
                    println!("{:?}", line);
                }
                println!("{}", "Adjacency matrix printed successfully".to_string().green());
            },
            22 => {
                export_graph(&graph);
                plot_graph();
                println!("{}", "Graph ploted successfully".to_string().green());
            },
            31 => {
                let cost = kruskal::minim(&mut graph);
                println!("{} MIN COST = {}",
                         "graph successfully reduced to Spanning tree".to_string().green(),
                         cost.to_string().bold().red().on_color("yellow"));
            },
            32 => {
                println!("Give spanning tree root:");
                let mut r: usize = read!();
                r -= 1usize;
                let cost = prim::minim(&r, &mut graph);
                println!("{} MIN COST = {}",
                         "graph successfully reduced to Spanning tree".to_string().green(),
                         cost.to_string().bold().red().on_color("yellow"));
            },
            4 => main_test(),
            _ => continue
        }
    }
}
