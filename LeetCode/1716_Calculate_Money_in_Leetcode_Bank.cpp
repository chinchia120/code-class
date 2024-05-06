#include <iostream>
using namespace std;

class Solution
{
public:
    int totalMoney(int n)
    {
        int loop = -1, sum = 0;
        for(int i = 1; i <= n; i++)
        {   
            int cnt;
            if(i%7 == 1) loop++;
            
            if(i%7 == 0) cnt = 7;
            else cnt = i%7;

            sum += cnt+loop;
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    int n = 20;
    Solution S;

    cout << S.totalMoney(n);

    return 0;
}