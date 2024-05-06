#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minOperations(vector<int>& nums)
    {
        if(nums.size() == 1) return 0;

        int sum = 0;
        for(int i = 1; i < nums.size(); i++)
        {
            if(nums[i] <= nums[i-1])
            {   
                int tmp = nums[i];
                nums[i] = nums[i-1]+1;
                sum += nums[i]-tmp;
            }
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,5,2,4,1};
    Solution S;

    cout << S.minOperations(nums);

    return 0;
}