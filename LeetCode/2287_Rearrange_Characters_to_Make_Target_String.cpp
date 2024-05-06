#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int rearrangeCharacters(string s, string target)
    {   
        vector<vector<int>> Counts;
        int index = 0;
        for(int i = 0; i < target.length(); i++)
        {   
            int flag = 0;
            for(int j = 0; j < Counts.size(); j++)
            {
                if((int)target[i] == Counts[j][0])
                {   
                    flag = 1;
                    Counts[j][1]++;
                    break;
                }
            }
            if(flag == 0)
            {
                Counts.push_back(vector<int> ());
                Counts[index].push_back((int)target[i]);
                Counts[index].push_back(1);
                Counts[index].push_back(0);
                index++;
            }
        }
        //Show1DVector(Counts);

        for(char ch: s)
        {
            for(int i = 0; i < Counts.size(); i++)
            {
                if((int)ch == Counts[i][0])
                {
                    Counts[i][2]++;
                    break;
                }
            }
        }
        //Show1DVector(Counts);

        int minCount = INT32_MAX;
        for(vector<int> Count: Counts) minCount = min(minCount, Count[2]/Count[1]);

        return minCount;
    }

    void Show1DVector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    string s = "ilovecodingonleetcode", target = "code";
    Solution S;

    cout << S.rearrangeCharacters(s, target);

    return 0;
}