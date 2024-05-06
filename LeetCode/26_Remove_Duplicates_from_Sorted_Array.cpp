#include <iostream>
#include <vector>
using namespace std;

class Solution 
{
public:
    int removeDuplicates(vector<int>& nums) 
    {   
        int cnt = 1;
        for(int i = 1; i < nums.size(); i++)
        {
            if(nums[i] != nums[i-1])
            {
                nums[cnt] = nums[i];
                cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> demo = {0, 0, 1, 1, 1, 2, 2, 3, 3, 4};
    Solution S;
    int ans = S.removeDuplicates(demo);

    cout << ans << " ";

    return 0;
}