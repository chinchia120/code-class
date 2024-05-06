#include <iostream>
using namespace std;

class Solution
{
public:
    string maximumOddBinaryNumber(string s)
    {   
        int cnt = 0;
        for(char ch: s) if(ch == '1') cnt++;

        for(int i = 0; i < s.length(); i++)
        {
            for(int j = i+1; j < s.length(); j++)
            {
                if(s[i] == '0' && s[j] == '1')
                {
                    s[i] = '1';
                    s[j] = '0';
                }
            }
        }
        
        if(cnt == 1)
        {
            s[0] = '0';
            s[s.length()-1] = '1';
        }
        else
        {
            s[cnt-1] = '0';
            s[s.length()-1] = '1';
        }
        return s;
    }
};

int main(int argc, char **argv)
{
    string s = "010";
    Solution S;

    cout << S.maximumOddBinaryNumber(s);

    return 0;
}