#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>
using namespace std;

class Solution
{
public:
    int findClosestNumber(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());

        int minDis = INT32_MAX, maxNum = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            if(abs(nums[i]) <= minDis)
            {
                if(abs(nums[i]) == minDis) maxNum = max(maxNum, nums[i]);
                else maxNum = nums[i];
                minDis = min(minDis, abs(nums[i]));
            }
        }
        return maxNum;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {-4,-2};
    Solution S;

    cout << S.findClosestNumber(nums);

    return 0;
}