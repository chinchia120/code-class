#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool divideArray(vector<int>& nums)
    {
        vector<int> counts (500, 0);
        for(int num: nums) counts[num-1]++;
        for(int count: counts) if(count%2 != 0) return false;
        return true;
    }
};