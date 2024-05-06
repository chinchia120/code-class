#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    int findNumbers(vector<int>& nums)
    {
        int cnt = 0;
        for(int i = 0; i < nums.size(); i++)
        {
            string str = to_string(nums[i]);
            if(str.length()%2 == 0) cnt++;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {555,901,482,1771};
    Solution S;

    cout << S.findNumbers(nums);

    return 0; 
}