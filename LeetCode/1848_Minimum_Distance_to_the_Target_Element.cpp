#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int getMinDistance(vector<int>& nums, int target, int start)
    {
        int len = INT32_MAX;
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i] == target) len = min(len, (i-start > 0) ? i-start : start-i);
        }
        return len;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,2,3,4,5};
    int target = 5, start = 3;
    Solution S;

    cout << S.getMinDistance(nums, target, start);

    return 0;
}