#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> evenOddBit(int n)
    {
        int even = 0, odd = 0, cnt = 0;
        while(n != 0)
        {
            int tmp = n%2;
            if(tmp == 1 && cnt%2 == 0) even++;
            if(tmp == 1 && cnt%2 == 1) odd++;
            n /= 2;
            cnt++;
        }
        return vector<int> {even, odd};
    }
};