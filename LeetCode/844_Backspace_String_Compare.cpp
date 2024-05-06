#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool backspaceCompare(string s, string t)
    {
        string str1 = "", str2 = "";
        for(int i = 0; i < s.length(); i++)
        {
            if(s[i] == '#')
            {
                if(!str1.empty()) str1.pop_back();
            }
            else
            {
                str1.push_back(s[i]);
            }
        }

        for(int i = 0; i < t.length(); i++)
        {
            if(t[i] == '#')
            {
                if(!str2.empty()) str2.pop_back();
            }
            else
            {
                str2.push_back(t[i]);
            }
        }
        cout << str1 << " " << str2 << endl;
        return str1 == str2;
    }
};

int main(int argc, char **argv)
{
    string s = "xywrrmp", t = "xywrrmu#p";
    Solution S;

    cout << S.backspaceCompare(s, t);

    return 0;
}