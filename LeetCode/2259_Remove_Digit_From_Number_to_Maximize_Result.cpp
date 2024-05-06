#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    string removeDigit(string number, char digit)
    {
        vector<string> num;
        for(int i = 0; i < number.length(); i++)
        {
            if(number[i] == digit)
            {
                string tmp = number;
                tmp.erase(tmp.begin()+i);
                num.push_back(tmp);
            }
        }
        sort(num.begin(), num.end());

        return num.back();
    }
};