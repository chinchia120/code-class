#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int largestSumAfterKNegations(vector<int>& nums, int k)
    {
        sort(nums.begin(), nums.end());
        for(int i = 0; i < nums.size(); i++)
        {
            if(k == 0) break;
            
            if(nums[i] < 0)
            {
                nums[i] = -nums[i];
                k--;
            }
            else if(nums[i] == 0)
            {
                k = 0;
            }
            else
            {
                break;
            }
        }

        sort(nums.begin(), nums.end());
        if(k % 2 == 1) nums[0] = -nums[0]; 

        int sum = 0;
        for(int i = 0; i < nums.size(); i++) sum += nums[i];
        return sum;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {3,-1,0,2};
    int k = 3;
    Solution S;

    cout << S.largestSumAfterKNegations(nums, k);

    return 0; 
}