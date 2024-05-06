#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    vector<int> separateDigits(vector<int>& nums)
    {
        vector<int> digits;
        for(int num: nums)
        {
            if(num >= 10)
            {
                string str = to_string(num);
                for(char ch: str) digits.push_back(ch-'0');
            }
            else digits.push_back(num);
        }
        return digits;
    }
};