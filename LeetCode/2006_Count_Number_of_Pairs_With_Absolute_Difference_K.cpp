#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

class Solution
{
public:
    int countKDifference(vector<int>& nums, int k)
    {
        int cnt = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = i+1; j < nums.size(); j++)
            {
                if(abs(nums[i]-nums[j]) == k) cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {3,2,1,5,4};
    int k = 2;
    Solution S;

    cout << S.countKDifference(nums, k);

    return 0;
}