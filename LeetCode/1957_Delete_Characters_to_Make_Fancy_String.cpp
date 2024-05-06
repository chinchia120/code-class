#include <iostream>
using namespace std;

class Solution
{
public:
    string makeFancyString(string s)
    {
        string str = "";
        str.push_back(s[0]);

        int cnt = 1;
        for(int i = 1; i < s.length(); i++)
        {
            if(s[i] == s[i-1]) cnt++;
            else cnt = 1;

            if(cnt >= 3) continue;
            else str.push_back(s[i]);
        }
        return str;
    }
};

int main(int argc, char **argv)
{
    string s = "aaabaaaa";
    Solution S;

    cout << S.makeFancyString(s);

    return 0;
}