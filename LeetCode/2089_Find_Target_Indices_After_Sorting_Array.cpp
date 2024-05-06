#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> targetIndices(vector<int>& nums, int target)
    {
        sort(nums.begin(), nums.end());

        vector<int> indexs;
        for(int i = 0; i < nums.size(); i++) 
        {
            if(nums[i] == target) indexs.push_back(i);
        }
        return indexs;
    }
};