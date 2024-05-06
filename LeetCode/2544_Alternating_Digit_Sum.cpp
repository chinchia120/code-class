#include <iostream>
using namespace std;

class Solution
{
public:
    int alternateDigitSum(int n)
    {
        int cnt = 0, sum = 0;
        while(n != 0)
        {
            if(cnt%2 == 0) sum += n%10;
            if(cnt%2 == 1) sum += -n%10;
            cnt++;
            n /= 10;
        }
        return (cnt%2 == 0)? -sum: sum;
    }
};