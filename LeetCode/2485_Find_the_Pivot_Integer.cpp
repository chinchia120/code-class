#include <iostream>
using namespace std;

class Solution
{
public:
    int pivotInteger(int n)
    {   
        int sum = 0;
        for(int i = 1; i <= n; i++) sum += i;

        for(int i = n; i >= 1; i--)
        {   
            int LHS = 0, RHS = 0;
            for(int j = 1; j <= i; j++) LHS += j;
            RHS = sum - LHS + i;
            if(LHS == RHS) return i;
        }
        return -1;
    }
};

int main(int argc, char **argv)
{
    int n = 8;
    Solution S;

    cout << S.pivotInteger(n);

    return 0;
}