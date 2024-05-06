#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int specialArray(vector<int>& nums)
    {
        int _max = 0;
        for(int num: nums) _max = max(_max, num);

        sort(nums.begin(), nums.end());
        
        for(int i = (_max, nums.size()); i > 0; i--)
        {
            int cnt = 0;
            for(int j = nums.size()-1; j >= 0; j--)
            {   
                if(nums[j] < i) break;
                cnt++;
            }
            if(cnt == i) return i;
        }
        return -1;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {0,4,3,0,4};
    Solution S;

    cout << S.specialArray(nums);

    return 0;
}