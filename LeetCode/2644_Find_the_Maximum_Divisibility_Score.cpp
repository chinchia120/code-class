#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maxDivScore(vector<int>& nums, vector<int>& divisors)
    {   
        vector<int> DivCnt {INT32_MAX, 0};
        for(int divisor: divisors)
        {
            int cnt = 0;
            for(int num: nums) if(num%divisor == 0) cnt++;

            if(DivCnt[1] < cnt) DivCnt = {divisor, cnt};
            if(DivCnt[1] == cnt) if(DivCnt[0] > divisor) DivCnt = {divisor, cnt};
        }
        return DivCnt[0];
    }
};