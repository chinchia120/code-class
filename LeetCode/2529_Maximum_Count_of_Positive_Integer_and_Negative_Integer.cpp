#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maximumCount(vector<int>& nums)
    {
        int cntPos = 0, cntNeg = 0;
        for(int num: nums)
        {
            if(num > 0) cntPos++;
            if(num < 0) cntNeg++;
        }
        return max(cntPos, cntNeg);
    }
};