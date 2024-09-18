#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

class Solution
{
public:
    string finalString(string s)
    {
        string tmp = "";
        for (char ch: s)
        {
            if (ch == 'i') reverse(tmp.begin(), tmp.end());
            else tmp.push_back(ch);
        }
        return tmp;
    }
};