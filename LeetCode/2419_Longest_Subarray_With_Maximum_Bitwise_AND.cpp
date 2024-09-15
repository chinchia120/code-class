#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int longestSubarray(vector<int>& nums)
    {
        int MaxNum = *max_element(nums.begin(), nums.end());
        int cnt = 0, index = 0, Maxcnt = 1;
        for (int i = 0; i < nums.size(); i++)
        {
            if (nums[i] == MaxNum)
            {
                cnt++;
            }
            else
            {   
                if (cnt > Maxcnt) Maxcnt = cnt;
                cnt = 0;
            }
        }
        if (cnt > Maxcnt) Maxcnt = cnt;
        return Maxcnt;
    }
};