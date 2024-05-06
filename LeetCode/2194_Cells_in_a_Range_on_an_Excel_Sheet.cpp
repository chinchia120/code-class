#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    vector<string> cellsInRange(string s)
    {   
        vector<string> ExcelRange;
        for(int i = (int)s[0]; i <= (int)s[3]; i++)
        {   
            for(int j = s[1]-'0'; j <= s[4]-'0'; j++)
            {   
                string str = "";
                str.push_back((char)i);
                str.push_back(j+'0');
                ExcelRange.push_back(str);
            }
        }
        return ExcelRange;
    }
};