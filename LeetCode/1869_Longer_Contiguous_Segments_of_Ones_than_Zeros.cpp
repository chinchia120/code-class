#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool checkZeroOnes(string s)
    {   
        if(s.length() == 1 && s[0] == '1') return true;
        if(s.length() == 1 && s[0] == '0') return false;

        int max0 = 0, max1 = 0, cnt = 1;
        char prev = s[0];
        for(int i = 1; i < s.length(); i++)
        {
            if(s[i] == prev) cnt++;
            else
            {
                if(prev == '0') max0 = max(max0, cnt);
                if(prev == '1') max1 = max(max1, cnt);
                cnt = 1;
                prev = s[i];
            }

            if(i == s.length()-1)
            {
                if(prev == '0') max0 = max(max0, cnt);
                if(prev == '1') max1 = max(max1, cnt);
            }
        }
        return (max1 > max0)? true: false;
    }
};

int main(int argc, char **argv)
{
    string s = "110100010";
    Solution S;

    cout << S.checkZeroOnes(s);

    return 0;
}