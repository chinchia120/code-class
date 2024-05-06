#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

class Solution
{
public:
    int countTriples(int n)
    {   
        if(n < 5) return 0;

        int cnt = 0;
        for(int i = 5; i <= n; i++)
        {
            for(int j = 3; j < i; j++)
            {
                int k = sqrt((i*i)-(j*j));
                if((j*j)+(k*k) == (i*i)) cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    int n = 10;
    Solution S;

    cout << S.countTriples(n);

    return 0;
}