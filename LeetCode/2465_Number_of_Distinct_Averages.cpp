#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int distinctAverages(vector<int>& nums)
    {   
        sort(nums.begin(), nums.end());

        vector<double> avgs;
        for(int i = 0; i < nums.size()/2; i++)
        {
            double avg = (double)(nums[i]+nums[nums.size()-1-i])/2;
            int flag = 0;
            for(int j = 0; j < avgs.size(); j++)
            {
                if(avgs[j] == avg)
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) avgs.push_back(avg);
        }
        //Show1DVector(avgs);
        return avgs.size();
    }

    void Show1DVector(vector<double> nums)
    {
        for(double num: nums) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {9,5,7,8,7,9,8,2,0,7};
    Solution S;

    cout << S.distinctAverages(nums);

    return 0;
}