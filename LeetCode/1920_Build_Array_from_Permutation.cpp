#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> buildArray(vector<int>& nums)
    {
        vector<int> arr (nums.size(), 0);
        for(int i = 0; i < arr.size(); i++)
        {
            arr[i] = nums[nums[i]];
        }
        return arr;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {5,0,1,2,3,4};
    Solution S;

    S.show_1d_vector(S.buildArray(nums));

    return 0;
}