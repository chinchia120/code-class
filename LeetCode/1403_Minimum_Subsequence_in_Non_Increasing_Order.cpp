#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> minSubsequence(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());

        int sumL = 0;
        for(int num: nums) sumL += num;

        int sumR = 0;
        vector<int> minArr;
        for(int i = nums.size()-1; i >= 0; i--)
        {   
            minArr.push_back(nums[i]);
            sumR += nums[i];
            sumL -= nums[i];
            if(sumL < sumR) return minArr;
        }
        return minArr;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {4,3,10,9,8};
    Solution S;

    S.show_1d_vector(S.minSubsequence(nums));

    return 0;
}