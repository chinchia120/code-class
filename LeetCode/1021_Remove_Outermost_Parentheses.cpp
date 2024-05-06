#include <iostream>
using namespace std;

class Solution
{
public:
    string removeOuterParentheses(string s)
    {
        int cnt = 0;
        string str = "";
        for(int i = 0; i < s.length(); i++)
        {
            if(s[i] == '(') cnt++;
            else cnt--;

            if(s[i] == '(' && cnt == 1) continue;
            else if(s[i] == ')' && cnt == 0) cnt = 0;
            else str.push_back(s[i]);
        }
        return str;
    }
};

int main(int argc, char ** argv)
{
    string s = "(()())(())";
    Solution S;

    cout << S.removeOuterParentheses(s);

    return 0;
}