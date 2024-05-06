#include <iostream>
#include <string>
using namespace std;

class Solution 
{
public:
    int lengthOfLongestSubstring(string s) 
    {   
        if(s == "") return 0;

        int max_len = 1;
        string check = "";
        check.push_back(s[0]);
        for(int i = 1; i < s.length(); i++)
        {   
            int flag = 0;
            for(int j = 0; j < check.length(); j++)
            {   
                if(s[i] == check[j]) flag = 1;
            }

            if(flag == 1)
            {
                check = "";
            }
            check.push_back(s[i]);
            
            int len = check.length();
            //cout << check << " " << len << endl;
            max_len = max(max_len, len);
        }
        return max_len;
    }
};

int main(int argc, char **argv)
{
    string str = "pwwkew";

    Solution S;
    int ans = S.lengthOfLongestSubstring(str);

    cout << ans;

    return 0;
}