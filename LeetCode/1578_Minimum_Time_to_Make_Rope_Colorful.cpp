#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minCost(string colors, vector<int>& neededTime)
    {
        char prev = colors[0];
        vector<int> time = {neededTime[0]}, time_rem;
        for(int i = 1; i < colors.length(); i++)
        {
            if(prev == colors[i])
            {
                time.push_back(neededTime[i]);
            }

            if(i == colors.length()-1 || prev != colors[i])
            {
                int max_time = 0;
                for(int j = 0; j < time.size(); j++)
                {
                    if(time[j] > max_time)
                    {
                        max_time = time[j];
                    }
                }
                time_rem.push_back(max_time);

                time.clear();
                time.push_back(neededTime[i]);

                prev = colors[i];
            }

            if(i == colors.length()-1 && colors[i-1] != colors[i])
            {
                time_rem.push_back(neededTime[i]);
            }
        }
        return sum_vector(neededTime) - sum_vector(time_rem);
    }

    int sum_vector(vector<int> vec)
    {
        int sum = 0;
        for(int i = 0; i < vec.size(); i++) sum += vec[i];
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
    //string colors = "aabaa";
    //vector<int> neededtime = {1,2,3,4,1};
    string colors = "abaac";
    vector<int> neededtime = {1,2,3,4,5};
    Solution S;

    cout << S.minCost(colors, neededtime);

    return 0;
}