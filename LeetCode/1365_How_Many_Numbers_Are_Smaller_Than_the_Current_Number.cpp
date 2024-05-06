#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> smallerNumbersThanCurrent(vector<int>& nums)
    {
        vector<int> nums_sort = nums;
        sort(nums_sort.begin(), nums_sort.end());

        vector<vector<int>> nums_count (nums.size(), vector<int> (2, 0));
        nums_count[0][0] = nums_sort[0];
        int cnt = 1;
        for(int i = 1; i < nums_sort.size(); i++)
        {   
            nums_count[i][0] = nums_sort[i];
            if(nums_sort[i] == nums_sort[i-1])
            {
                nums_count[i][1] = nums_count[i-1][1];
                cnt++;
            }
            else
            {
                nums_count[i][1] = nums_count[i-1][1]+cnt;
                cnt = 1;
            }
        }
        //show_2d_vector(nums_count);

        vector<int> count (nums.size(), 0);
        for(int i = 0; i < nums.size(); i++)
        {
            for(int j = 0; j < nums_count.size(); j++)
            {
                if(nums[i] == nums_count[j][0])
                {
                    count[i] = nums_count[j][1];
                    nums_count[j].clear();
                }
            }
        }
        return count;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(vector<int> vec1: vec)
        {
            for(int num: vec1) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {8,1,2,2,3};
    Solution S;

    S.show_1d_vector(S.smallerNumbersThanCurrent(nums));

    return 0;
}