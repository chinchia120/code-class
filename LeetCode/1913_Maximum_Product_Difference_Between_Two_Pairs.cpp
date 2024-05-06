#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int maxProductDifference(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());

        return (nums[nums.size()-1]*nums[nums.size()-2]) - nums[0]*nums[1];
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {4,2,5,9,7,4,8};
    Solution S;

    cout << S.maxProductDifference(nums);

    return 0;
}