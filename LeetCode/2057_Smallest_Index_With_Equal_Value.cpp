#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int smallestEqual(vector<int>& nums)
    {
        for(int i = 0; i < nums.size(); i++)
        {
            if(i%10 == nums[i]) return i;
        }
        return -1;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {4,3,2,1};
    Solution S;

    cout << S.smallestEqual(nums);

    return 0;
}