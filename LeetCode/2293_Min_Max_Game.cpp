#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minMaxGame(vector<int>& nums)
    {   
        while(nums.size() != 1)
        {   
            vector<int> nums2;
            for(int i = 0; i < nums.size(); i+=2)
            {
                if(i%4 == 0) nums2.push_back(min(nums[i], nums[i+1]));
                else nums2.push_back(max(nums[i], nums[i+1]));
            }
            nums = nums2;
        }
        return nums[0];
    }
};