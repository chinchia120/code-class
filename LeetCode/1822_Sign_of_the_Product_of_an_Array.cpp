#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int arraySign(vector<int>& nums)
    {
        int check = 1;
        for(int num: nums)
        {
            if(num < 0) check *= -1;
            if(num == 0) return 0;
        }
        return check;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {-1,-2,-3,-4,3,2,1};
    Solution S;

    cout << S.arraySign(nums);

    return 0;
}