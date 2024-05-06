#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maxAscendingSum(vector<int>& nums)
    {
        int sum = nums[0], prev = nums[0], maxSum = nums[0];
        for(int i = 1; i < nums.size(); i++)
        {
            if(nums[i] > prev)
            {
                sum += nums[i];
                prev = nums[i];
            }
            else
            {
                maxSum = max(maxSum, sum);
                sum = nums[i];
                prev = nums[i];
            }

            if(i == nums.size()-1) maxSum = max(maxSum, sum);
        }
        return maxSum;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {12,17,15,13,10,11,12};
    Solution S;

    cout << S.maxAscendingSum(nums);

    return 0;
}