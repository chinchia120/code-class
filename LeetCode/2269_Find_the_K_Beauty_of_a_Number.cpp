#include <iostream>
#include <string>
using namespace std;

class Solution
{
public:
    int divisorSubstrings(int num, int k)
    {
        string str = to_string(num);
        int cnt = 0;
        for(int i = 0; i < str.length()-k+1; i++)
        {
            int tmp = stoi(str.substr(i, k));
            if(tmp == 0) continue;
            else if(num%tmp == 0) cnt++;
        }
        return cnt;
    }
};