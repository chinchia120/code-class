#include <iostream>
using namespace std;

class Solution
{
public:
    bool divisorGame(int n)
    {
        return n%2 == 0;
    }
};

int main(int argc, char **argv)
{
    int n = 3;
    Solution S;

    cout << S.divisorGame(n);

    return 0;
}