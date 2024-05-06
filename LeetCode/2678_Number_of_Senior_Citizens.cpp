#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int countSeniors(vector<string>& details)
    {
        int cnt = 0;
        for(string detail: details)
        {
            if(stoi(detail.substr(11, 2)) > 60) cnt++;
        }
        return cnt;
    }
};