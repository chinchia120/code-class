#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> sortArrayByParityII(vector<int>& nums)
    {   
        vector<int> even, odd;
        for(int i = 0; i < nums.size(); i++)
        {
            if(nums[i]%2 == 0) even.push_back(nums[i]);
            else odd.push_back(nums[i]);
        }

        int index = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            if(i%2 == 0)
            {
                nums[i] = even[index];
            }
            else
            {
                nums[i] = odd[index];
                index++;
            }
        }
        return nums;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {4, 2, 5, 7};
    Solution S;

    S.show_1d_vector(S.sortArrayByParityII(nums));

    return 0;
}