#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    string bestHand(vector<int>& ranks, vector<char>& suits)
    {   
        int flag = 1;
        for(int i = 1; i < suits.size(); i++)
        {
            if(suits[i] != suits[i-1])
            {
                flag = 0;
                break;
            }
        }
        if(flag == 1) return "Flush";

        sort(ranks.begin(), ranks.end());
        int cnt = 1, prev = ranks[0], MaxCnt = 1;
        for(int i = 1; i < ranks.size(); i++)
        {   
            if(prev == ranks[i])
            {
                cnt++;
            }
            else
            {
                prev = ranks[i];
                MaxCnt = max(MaxCnt, cnt);
                cnt = 1;
            }
        }
        MaxCnt = max(MaxCnt, cnt);
        if(MaxCnt >= 3) return "Three of a Kind";
        if(MaxCnt >= 2) return "Pair";
        return "High Card";
    }
};

int main(int argc, char **argv)
{
    vector<int> ranks = {14,14,2,14,4};
    vector<char> suits = {'a','b','a','a','a'};
    Solution S;

    cout << S.bestHand(ranks, suits);

    return 0;
}