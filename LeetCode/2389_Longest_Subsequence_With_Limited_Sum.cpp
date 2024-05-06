#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> answerQueries(vector<int>& nums, vector<int>& queries)
    {
        sort(nums.begin(), nums.end());

        for(int i = 0; i < queries.size(); i++)
        {   
            int sum = 0;
            for(int j = 0; j < nums.size(); j++)
            {
                sum += nums[j];
                if(sum > queries[i])
                {
                    queries[i] = j;
                    sum -= nums[j];
                    break;
                }

                if(j == nums.size()-1) queries[i] = nums.size();
            }
        }
        return queries;
    }

    void Show1DVector(vector<int> nums)
    {
        for(int num: nums) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> nums = {4,5,2,1};
    vector<int> queries = {3,10,21};
    Solution S;

    S.Show1DVector(S.answerQueries(nums, queries));

    return 0;
}