#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool canBeIncreasing(vector<int>& nums)
    {
        for(int i = 0; i < nums.size(); i++)
        {   
            vector<int> tmp = nums;
            tmp.erase(tmp.begin()+i);

            int cnt = 0;
            for(int j = 1; j < tmp.size(); j++)
            {   
                if(tmp[j] <= tmp[j-1]) cnt++;
                if(cnt == 1) break;
            }
            if(cnt == 0) return true;
        }
        return false;
    }
};

int main(int argc, char **argv)
{
    //vector<int> nums = {2,3,1,2};
    vector<int> nums = {1,2,10,5,7};
    Solution S;

    cout << S.canBeIncreasing(nums);

    return 0;
}