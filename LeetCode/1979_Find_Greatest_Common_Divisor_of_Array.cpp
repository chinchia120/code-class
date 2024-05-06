#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int findGCD(vector<int>& nums)
    {
        int minNum = INT32_MAX, maxNum = 0;
        for(int num: nums)
        {
            minNum = min(minNum, num);
            maxNum = max(maxNum, num);
        }

        for(int i = minNum; i > 1; i--)
        {
            if(minNum%i == 0 && maxNum%i == 0) return i;
        }
        return 1;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {2,5,6,9,10};
    Solution S;

    cout << S.findGCD(nums);

    return 0;
}