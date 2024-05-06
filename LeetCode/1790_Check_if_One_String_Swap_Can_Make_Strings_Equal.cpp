#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool areAlmostEqual(string s1, string s2)
    {   
        if(s1 == s2) return true;
        
        int cnt = 0;
        vector<int> str1, str2;
        for(int i = 0; i < s1.length(); i++)
        {
            if(s1[i] != s2[i]) 
            {
                cnt++;
                str1.push_back((int)s1[i]);
                str2.push_back((int)s2[i]);
            }
        }
        sort(str1.begin(), str1.end());
        sort(str2.begin(), str2.end());

        return ((cnt == 2 || cnt == 0) && str1 == str2)? true: false; 
    }
};

int main(int argc, char **argv)
{
    string s1 = "bank", s2 = "kanb";
    Solution S;

    cout << S.areAlmostEqual(s1, s2);

    return 0;
}