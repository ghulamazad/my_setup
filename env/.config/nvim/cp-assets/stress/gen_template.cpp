// Copy to gen.cpp in a problem folder and edit the ranges.
#include <bits/stdc++.h>
using namespace std;

int main(int argc, char* argv[]) {
    srand(atoi(argv[1])); // seed comes from stress.sh, so every run differs

    int n = rand() % 10 + 1; // adjust to the problem's constraints
    cout << n << "\n";
    for (int i = 0; i < n; i++) {
        cout << (rand() % 100) << " ";
    }
    cout << "\n";

    return 0;
}
