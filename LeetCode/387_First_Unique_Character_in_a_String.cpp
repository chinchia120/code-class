#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int firstUniqChar(string s)
    {
        vector<vector<int>> counts;
        for(int i = 0; i < s.length(); i++)
        {
            int flag = 0;
            for(int j = 0; j < counts.size(); j++)
            {
                if((int)s[i] == counts[j][0])
                {
                    flag = 1;
                    counts[j][2]++;
                    break;
                }
            }
            if(flag == 0)
            {
                counts.push_back(vector<int> ());
                counts[counts.size()-1].push_back((int)s[i]);
                counts[counts.size()-1].push_back(i);
                counts[counts.size()-1].push_back(1);
            }
        }

        for(vector<int> count: counts)
        {
            if(count[2] == 1) return count[1];
        }
        return -1;
    }
};