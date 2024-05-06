#include <iostream>
using namespace std;

class Solution
{
public:
    int balancedStringSplit(string s)
    {
        int res = 0, cnt = 0;
        for(int i = 0; i < s.length(); i++)
        {   
            (s[i] == 'R') ? cnt++ : cnt--;
            if(cnt == 0) res++;
        }
        return res;
    }
};

int main(int argc, char **argv)
{
    string s = "RLRRLLRLRL";
    Solution S;

    cout << S.balancedStringSplit(s);

    return 0;
}