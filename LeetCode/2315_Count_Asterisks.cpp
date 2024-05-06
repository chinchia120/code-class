#include <iostream>
using namespace std;

class Solution
{
public:
    int countAsterisks(string s)
    {
        int flag = 0, cnt = 0;
        for(char ch: s)
        {
            if(ch == '|') flag++;
            if(flag%2 == 0 && ch == '*') cnt++;
        }
        return cnt;
    }
};