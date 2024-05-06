#include <iostream>
using namespace std;

class Solution
{
public:
    int countOdds(int low, int high)
    {
        if(low%2 == 0 && high%2 == 0) return (high-low)/2;
        else return (high-low)/2+1;
    }
};

int main(int argc, char **argv)
{
    int low = 3, high = 7;
    Solution S;

    cout << S.countOdds(low, high);

    return 0;
}