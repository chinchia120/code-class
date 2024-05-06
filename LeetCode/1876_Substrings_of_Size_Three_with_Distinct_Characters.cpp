#include <iostream>
using namespace std;

class Solution
{
public:
    int countGoodSubstrings(string s)
    {   
        if(s.length() < 3) return false;
        
        int cnt = 0;
        for(int i = 0; i < s.length()-2; i++)
        {
            if(s[i] != s[i+1] && s[i] != s[i+2] && s[i+1] != s[i+2]) cnt++;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    string s = "aababcabc";
    Solution S;

    cout << S.countGoodSubstrings(s);

    return 0;
}