#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int maxProduct(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());
        return (nums[nums.size()-1]-1) * (nums[nums.size()-2]-1);
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {3, 4, 5, 2};
    Solution S;

    cout << S.maxProduct(nums);

    return 0;
}