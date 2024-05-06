#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<bool> prefixesDivBy5(vector<int>& nums)
    {
        vector<bool> check_list;
        int sum = 0;
        for(int i = 0; i < nums.size(); i++)
        {   
            sum = (sum*2 + nums[i]) % 10;

            if(sum%5 == 0) check_list.push_back(true);
            else check_list.push_back(false);
        }
        return check_list;
    }

    void show_1d_vector(vector<bool> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {1,0,0,1,0,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,1,0,0,0,0,1,1,0,1,0,0,0,1};
    Solution S;

    S.show_1d_vector(S.prefixesDivBy5(nums));

    return 0;
}