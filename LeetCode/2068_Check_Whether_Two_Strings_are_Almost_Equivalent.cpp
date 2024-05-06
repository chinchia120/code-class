#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

class Solution
{
public:
    bool checkAlmostEquivalent(string word1, string word2)
    {
        vector<int> cnt1 = CountString(word1), cnt2 = CountString(word2);
        for(int i = 0; i < cnt1.size(); i++) if(abs(cnt1[i]-cnt2[i]) > 3) return false;
        return true;
    }

    vector<int> CountString(string str)
    {
        vector<int> cnt (26, 0);
        for(char ch: str) cnt[(int)ch-97]++;
        return cnt;
    }
};