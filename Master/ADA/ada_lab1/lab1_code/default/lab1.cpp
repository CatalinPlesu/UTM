#include "sha256.h"
#include <iostream> 
#include <cstdint>
#include <chrono>

std::string solve_crypto_puzzle(std::string str, uint puzzle_difficulty)
{
    std::string nonce_needle(puzzle_difficulty, '0');

    SHA256 sha256;
    for(uint64_t i=0; i < UINT64_MAX; i++){
        std::string solution_candidate = str + std::to_string(i);
        std::string hash_code = sha256(solution_candidate);

        if(hash_code.compare(0, puzzle_difficulty, nonce_needle) == 0){
            return solution_candidate;
        }
    }
    throw "No result found";
}

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

int main(int argc, char *argv[])
{
    check_comandline_passed_arguments(argc, argv);

    int difficulty = atoi(argv[1]);
    SHA256 sha256;
    const std::string message("Hello World");

    std::cout << "Message:" << std::endl << message << std::endl;
    std::cout << "Hash:" << std::endl << sha256(message) << std::endl;
    std::cout << std::endl << std::endl;
    std::cout << "Looking for nonce to solve crypto-puzzle with level " << difficulty << " difficulty" << "..." << std::endl;
    auto t1 = std::chrono::high_resolution_clock::now();
    try
    {
        auto solution = solve_crypto_puzzle(message, difficulty);

        std::cout << "Solution: " << std::endl << solution << std::endl;
        std::cout << "Hash:" << std::endl << sha256(solution) << std::endl;
    }
    catch(const char* msg)
    {
        std::cout << msg << std::endl;
    }

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration_milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);

    std::cout << duration_milliseconds.count() << " milliseconds\n";
}