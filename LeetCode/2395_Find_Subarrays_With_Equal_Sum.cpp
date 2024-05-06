#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool findSubarrays(vector<int>& nums)
    {
        vector<int> sums;
        for(int i = 1; i < nums.size(); i++)
        {
            int tmp = nums[i]+nums[i-1];
            for(int sum: sums) if(sum == tmp) return true;
            sums.push_back(tmp);
        }
        return false;
    }
};