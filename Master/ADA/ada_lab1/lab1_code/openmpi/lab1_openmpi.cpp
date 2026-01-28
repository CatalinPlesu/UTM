#include <mpi.h>
#include "sha256.h"
#include <iostream> 
#include <cstdint>
#include <chrono>
#include <string>
#include <cstdlib>

int check_comandline_passed_arguments(int argc, char *argv[])
{
    char* app_name = argv[0];
    if(argc == 1){
        std::cout << "Call application "<< app_name << " with arguments [n]." << std::endl;
        std::cout << "Example:" << std::endl;
        std::cout << app_name <<" 7 -- Application will try to solve crypto puzzle SHA256 with nonce that will generate 7 trailing 0 of the hashed message." << std::endl;
        std::cout << app_name <<" 8 -- Application will try to solve crypto puzzle SHA256 with nonce that will generate 8 trailing 0 of the hashed message." << std::endl;

        exit(0);
    }
    if(argc > 2)
    {
        std::cout << "Incorrect arguments passed." << std::endl;
        std::cout << "Call application "<< app_name << " for help message" << std::endl;
        exit(1);
    }
    return 0;
}

std::string solve_crypto_puzzle(std::string str, uint puzzle_difficulty, int world_rank, int world_size)
{
    std::string nonce_needle(puzzle_difficulty, '0');
    SHA256 sha256;
    
    // Each process starts from its rank and increments by world_size
    for(uint64_t i = world_rank; i < UINT64_MAX; i += world_size){
        std::string solution_candidate = str + std::to_string(i);
        std::string hash_code = sha256(solution_candidate);
        
        // Check if hash starts with required number of zeros
        if(hash_code.compare(0, puzzle_difficulty, nonce_needle) == 0) {
            return solution_candidate;
        }
    }
    return ""; // Return empty string if no solution found
}

int main (int argc, char *argv[]) 
{
    std::setbuf(stdout, NULL);
    check_comandline_passed_arguments(argc, argv);

    int difficulty = atoi(argv[1]);
    SHA256 sha256;
    const std::string message("Hello World");

    std::cout << "Message:" << std::endl << message << std::endl;
    // std::cout << "Hash:" << std::endl << sha256(message) << std::endl;
    std::cout << std::endl << std::endl;
    std::cout << "Looking for nonce to solve crypto-puzzle with level " << difficulty << " difficulty" << "..." << std::endl;

    auto t1 = std::chrono::high_resolution_clock::now();

    // Initialize the MPI environment
    MPI_Init(NULL, NULL);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello message from each processor
    std::cout << "Hello from processor " << processor_name << ", rank " << world_rank << " out of " << world_size << " processors" << std::endl;

    // Solve crypto puzzle with distributed computation
    std::string local_solution = solve_crypto_puzzle(message, difficulty, world_rank, world_size);

    // Gather results from all processes
    char local_result[1000] = {0};
    char global_results[1000 * world_size] = {0};
    
    if(!local_solution.empty()) {
        strncpy(local_result, local_solution.c_str(), sizeof(local_result) - 1);
    }
    
    // Gather all results to rank 0
    MPI_Gather(local_result, 1000, MPI_CHAR, global_results, 1000, MPI_CHAR, 0, MPI_COMM_WORLD);

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration_milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);

    // Only rank 0 processes and displays results
    if(world_rank == 0) {
        std::string final_solution;
        bool solution_found = false;
        
        // Check all gathered results
        for(int i = 0; i < world_size; i++) {
            std::string result(&global_results[i * 1000]);
            if(!result.empty()) {
                final_solution = result;
                solution_found = true;
                std::cout << "Process " << i << " found solution: " << result << std::endl;
                std::cout << "Hash: " << sha256(result) << std::endl;
                break; // Take the first solution found
            }
        }
        
        if(solution_found) {
            std::cout << "Final solution: " << final_solution << std::endl;
        } else {
            std::cout << "No solution found within search range." << std::endl;
        }
        
        std::cout << duration_milliseconds.count() << " milliseconds" << std::endl;
}

    MPI_Finalize();
    return 0;
}