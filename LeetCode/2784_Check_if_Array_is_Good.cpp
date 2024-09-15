#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool isGood(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());

        if (nums.front() != 1 || nums.back() != nums.size()-1) return false;
        for (int i = 1; i < nums.size()-1; i++) if (nums[i] != i+1) return false; 
        return true;
    }
};