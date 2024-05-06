#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int secondHighest(string s)
    {
        vector<int> num;
        
        for(char ch: s)
        {   
            if(0 <= ch-'0' && ch-'0' <= 9)
            {   
                int flag = 0;
                for(int i = 0; i < num.size(); i++)
                {
                    if(num[i] == ch-'0')
                    {
                        flag = 1;
                        break;
                    }
                }
                if(flag == 0) num.push_back(ch-'0');
            }
        }
        
        if(num.size() == 1 || num.size() == 0) return -1;
        else
        {
            sort(num.begin(), num.end());
            return num[num.size()-2];
        }
    }
};

int main(int argc, char **argv)
{
    string s = "wnbvkpdvaps2228282282";
    Solution S;

    cout << S.secondHighest(s);

    return 0;
}