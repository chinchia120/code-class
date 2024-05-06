#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

class Solution
{
public:
    string largestGoodInteger(string num)
    {
        vector<string> GoodIntegers;
        for(int i = 0; i < num.length()-2; i++)
        {
            if(num[i] == num[i+1] && num[i] == num[i+2]) GoodIntegers.push_back(num.substr(i, 3));
        }
        sort(GoodIntegers.begin(), GoodIntegers.end());

        return (!GoodIntegers.empty())? GoodIntegers.back(): "";
    }
};