#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int minimizedStringLength(string s)
    {   
        vector<int> CharNums;
        for(char ch: s)
        {
            int flag = 0;
            for(int CharNum: CharNums)
            {
                if((int)ch == CharNum)
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) CharNums.push_back((int)ch);
        }
        return CharNums.size();
    }
};