#!/usr/bin/env bash
# Usage: stress.sh <folder with sol.cpp, brute.cpp, gen.cpp> [max_iterations]

set -e

DIR="${1:-.}"
MAX_ITER="${2:-1000}"

cd "$DIR"

echo "Compiling..."
g++ -std=c++20 -O2 -o sol sol.cpp
g++ -std=c++20 -O2 -o brute brute.cpp
g++ -std=c++20 -O2 -o gen gen.cpp

for ((i = 1; i <= MAX_ITER; i++)); do
    ./gen "$i" > input.txt
    ./sol < input.txt > sol_out.txt
    ./brute < input.txt > brute_out.txt

    if ! diff -q sol_out.txt brute_out.txt > /dev/null; then
        echo "=========================================="
        echo "MISMATCH FOUND on iteration $i"
        echo "=========================================="
        echo "--- Input ---"
        cat input.txt
        echo "--- Your solution output ---"
        cat sol_out.txt
        echo "--- Brute force output ---"
        cat brute_out.txt
        exit 1
    fi

    if ((i % 50 == 0)); then
        echo "  $i tests passed..."
    fi
done

echo "All $MAX_ITER tests passed - no mismatch found."
