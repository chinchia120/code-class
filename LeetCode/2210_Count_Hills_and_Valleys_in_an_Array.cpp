#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countHillValley(vector<int>& nums)
    {
        nums = RemoveSameValue(nums);
        //show_1d_vector(nums);

        int cnt = 0;
        for(int i = 1; i < nums.size()-1; i++)
        {
            if(nums[i-1] < nums[i] && nums[i] > nums[i+1]) cnt++;
            if(nums[i-1] > nums[i] && nums[i] < nums[i+1]) cnt++;
        }
        return cnt;
    }

    vector<int> RemoveSameValue(vector<int> vec)
    {
        for(int i = 1; i < vec.size(); i++)
        {
            if(vec[i] == vec[i-1])
            {
                vec.erase(vec.begin()+i);
                i--;
            }
        }
        return vec;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {2,4,1,1,6,5};
    Solution S;

    cout << S.countHillValley(nums);

    return 0;
}