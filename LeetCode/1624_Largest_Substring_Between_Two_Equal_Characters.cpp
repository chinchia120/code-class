#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

class Solution
{
public:
    int maxLengthBetweenEqualCharacters(string s)
    {
        string str = s, str_twice = "";
        sort(str.begin(), str.end());

        int cnt = 1;
        char prev = str[0];
        for(int i = 1; i < str.length(); i++)
        {
            if(str[i] == prev) cnt++;
            else
            {
                if(cnt > 1) str_twice.push_back(prev);
                
                prev = str[i];
                cnt = 1;
            }
        }
        if(cnt > 1) str_twice.push_back(prev);
        
        int max_len = -1;
        vector<int> index;
        for(int i = 0; i < str_twice.length(); i++)
        {
            for(int j = 0; j < s.length(); j++)
            {
                if(str_twice[i] == s[j]) index.push_back(j);
            }
            max_len = max(max_len, index.back()-index[0]-1);
            index.clear();
        }
        return max_len;
    }
};

int main(int argc, char **argv)
{
    string s = "abcac";
    Solution S;

    cout << S.maxLengthBetweenEqualCharacters(s);

    return 0;
}