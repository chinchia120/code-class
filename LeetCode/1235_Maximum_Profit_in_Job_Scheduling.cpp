#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int jobScheduling(vector<int>& startTime, vector<int>& endTime, vector<int>& profit)
    {   
        int max_time = 0;
        vector<vector<int>> jobs (startTime.size(), vector<int> (3, 0));
        for(int i = 0; i < startTime.size(); i++)
        {
            jobs[i][0] = startTime[i];
            jobs[i][1] = endTime[i];
            jobs[i][2] = profit[i];
            max_time = max(max_time, endTime[i]);
        }
        sort(jobs.begin(), jobs.end());
        //show_2d_vector(jobs);

        int start_index = 0, end_index = 0, max_profit = 0;
        vector<int> dp (max_time+1, 0);
        for(int i = 1; i < dp.size(); i++)
        {
            for(int j = 0; j < jobs.size(); j++)
            {
                if(jobs[j][0] == i && max_profit < jobs[j][2])
                {
                    start_index = jobs[j][0];
                    end_index = jobs[j][1];
                    max_profit = jobs[j][2];
                    jobs[j].clear();
                    break;
                }
            }
            if(end_index == i+1) dp[i] = dp[i-1] + max_profit;
            else dp[i] = dp[i-1];
        }
        show_1d_vector(dp);


        return 0;
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
    vector<int> startTime = {1,2,3,3}, endTime = {3,4,5,6}, profit = {50,10,40,70};
    Solution S;

    cout << S.jobScheduling(startTime, endTime, profit);

    return 0;
}