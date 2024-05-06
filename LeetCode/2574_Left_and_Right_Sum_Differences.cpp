#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> leftRightDifference(vector<int>& nums)
    {
        int sum = 0, tmp = 0;
        for(int num: nums) sum += num;

        vector<int> diff (nums.size(), 0);
        for(int i = 0; i < diff.size(); i++)
        {   
            if(i == 0)
            {   
                tmp = sum-nums[i];
                diff[i] = abs(tmp);
            }
            else
            {   
                tmp = tmp-nums[i-1]-nums[i];
                diff[i] = abs(tmp);
            }
        }
        return diff;
    }
};