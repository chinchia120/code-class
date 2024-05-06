#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<vector<int>> divideArray(vector<int>& nums, int k)
    {
        sort(nums.begin(), nums.end());
        
        vector<vector<int>> vec;
        for(int i = 0; i < nums.size(); i++)
        {   
            if(i%3 == 0)
            {
                vec.push_back(vector<int> ());
                vec[vec.size()-1].push_back(nums[i]);
            }
            else if(i%3 == 1)
            {
                if(nums[i]-nums[i-1] > k) return vector<vector<int>> ();
                else vec[vec.size()-1].push_back(nums[i]);
            }
            else
            {
                if(nums[i]-nums[i-1] > k || nums[i]-nums[i-2] > k) return vector<vector<int>> ();
                else vec[vec.size()-1].push_back(nums[i]);
            }
        }
        return vec;
    }

    void Show2DVector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,3,4,8,7,9,3,5,1};
    int k = 2;
    Solution S;

    S.Show2DVector(S.divideArray(nums, k));

    return 0;
}