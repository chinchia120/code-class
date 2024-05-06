#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int minOperations(vector<int>& nums)
    {
        sort(nums.begin(), nums.end());

        int prev = nums[0], cnt = 1;
        vector<int> count;
        for(int i = 1; i < nums.size(); i++)
        {
            if(nums[i] == prev) cnt++;
            else
            {   
                if(cnt == 1) return -1;
                count.push_back(cnt);
                prev = nums[i];
                cnt = 1;
            }
        }
        if(cnt == 1) return -1;
        count.push_back(cnt);
        //show_1d_vector(count);

        int sum = 0;
        for(int i = 0; i < count.size(); i++)
        {
            if(count[i]%3 == 0) sum += count[i]/3;
            if(count[i]%3 == 1) sum += count[i]/3+1;
            if(count[i]%3 == 2) sum += count[i]/3+1;
        }
        return sum;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {2,3,3,2,2,4,2,3,4};
    Solution S;

    cout << S.minOperations(nums);

    return 0;
}