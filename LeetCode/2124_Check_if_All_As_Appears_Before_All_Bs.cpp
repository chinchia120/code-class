#include <iostream>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool checkString(string s)
    {
        string sCopy = s;
        sort(sCopy.begin(), sCopy.end());

        return (sCopy == s)? true: false;
    }
};