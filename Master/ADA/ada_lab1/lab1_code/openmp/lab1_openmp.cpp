#include <omp.h>
#include <iostream> 
#include <cstdint>
#include <chrono>
#include <atomic>
#include <string>
#include <cstdlib>
#include "sha256.h"

std::atomic<bool> found(false);
std::string global_solution;

int check_comandline_passed_arguments(int argc, char *argv[])
{
    char* app_name = argv[0];
    std::cout << "Count of arguments passed: " << argc << std::endl;
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

std::string solve_crypto_puzzle(std::string str, uint puzzle_difficulty, uint current_thread_id, uint total_threads)
{
    std::string nonce_needle(puzzle_difficulty, '0');
    SHA256 sha256;

    for (uint64_t i = current_thread_id; i < UINT64_MAX && !found.load(std::memory_order_acquire); i += total_threads)
    {
        std::string solution_candidate = str + std::to_string(i);
        std::string hash_code = sha256(solution_candidate);

        if (hash_code.compare(0, puzzle_difficulty, nonce_needle) == 0)
        {
            found.store(true, std::memory_order_release);
            return solution_candidate;
        }
    }
    return ""; // Return empty string if no solution found
}


int main (int argc, char *argv[]) 
{
    check_comandline_passed_arguments(argc, argv);

    int difficulty = atoi(argv[1]);
    SHA256 sha256;
    const std::string message("Hello World");

    std::cout << "Message:" << std::endl << message << std::endl;
    std::cout << "Hash:" << std::endl << sha256(message) << std::endl;
    std::cout << std::endl << std::endl;
    std::cout << "Looking for nonce to solve crypto-puzzle with " << difficulty << " difficulty" << "..." << std::endl;
    auto t1 = std::chrono::high_resolution_clock::now();

    std::cout << "Application with OpenMP parameters:" << std::endl;

    int total_threads, current_thread_id;
    #pragma omp parallel num_threads(NUM_THREADS) private(total_threads, current_thread_id)
    {
        current_thread_id = omp_get_thread_num();
        total_threads = omp_get_num_threads();
        std::cout << "Total threads: " << total_threads << std::endl;
        std::cout << "Current thread: " << current_thread_id << std::endl;
        
        // Insert your function here to solve crypto puzzle
        auto solution = solve_crypto_puzzle(message, difficulty, current_thread_id, total_threads);

        if (!solution.empty())
        {
#pragma omp critical
            {
                if (global_solution.empty())
                { // First thread to find solution
                    global_solution = solution;
                    std::cout << "Thread " << current_thread_id << ") Solution found:\n"
                              << solution << std::endl;
                    std::cout << "Thread " << current_thread_id << ") Hash:\n"
                              << sha256(solution) << std::endl;
                }
            }
        }
    }
    // Insert code to output the result

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration_milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);

    if (!global_solution.empty())
    {
        std::cout << "Final solution: " << global_solution << std::endl;
    }
    else
    {
        std::cout << "No solution found within search range." << std::endl;
    }

    std::cout << duration_milliseconds.count() << " milliseconds\n";

}
