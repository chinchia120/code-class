#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int prefixCount(vector<string>& words, string pref)
    {
        int cnt = 0;
        for(string word: words)
        {   
            int flag = 1;
            for(int i = 0; i < pref.length(); i++)
            {
                if(word[i] != pref[i])
                {
                    flag = 0;
                    break;
                }
            }
            if(flag == 1) cnt++;
        }
        return cnt;
    }
};