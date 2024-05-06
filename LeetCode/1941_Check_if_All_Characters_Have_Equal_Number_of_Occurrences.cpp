#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool areOccurrencesEqual(string s)
    {   
        vector<vector<int>> ch_cnt;
        int index = 0, maxCnt = 0, minCnt = INT32_MAX;
        for(char ch: s)
        {   
            int flag = 0;
            for(int i = 0; i < ch_cnt.size(); i++)
            {
                if((int)ch == ch_cnt[i][0])
                {
                    flag = 1;
                    ch_cnt[i][1]++;
                }
            }
            if(flag == 0)
            {
                ch_cnt.push_back(vector<int> ());
                ch_cnt[index].push_back((int)ch);
                ch_cnt[index].push_back(1);
                index++;
            }
        }
        
        for(int i = 0; i < ch_cnt.size(); i++)
        {
            maxCnt = max(maxCnt, ch_cnt[i][1]);
            minCnt = min(minCnt, ch_cnt[i][1]);
        }
        //cout << minCnt << " " << maxCnt << endl;
        return (maxCnt == minCnt)? true: false;
    }
};

int main(int argc, char **argv)
{
    //string s = "reflkmvaqwzfipn";
    string s = "abcabc";
    Solution S;

    cout << S.areOccurrencesEqual(s);

    return 0;
}