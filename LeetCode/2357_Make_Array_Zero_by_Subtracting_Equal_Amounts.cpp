#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int minimumOperations(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i] == 0 || (i != 0 && nums[i] == nums[i-1]))
            {
                nums.erase(nums.begin()+i);
                i--;
            }   
        }
        return nums.size();
    }
};