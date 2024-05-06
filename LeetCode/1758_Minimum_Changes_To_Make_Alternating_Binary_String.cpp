#include <iostream>
using namespace std;

class Solution
{
public:
    int minOperations(string s)
    {
        int cnt1 = 0, cnt2 = 0;
        for(int i = 0; i < s.length(); i++)
        {
            if(i%2 == 0 && s[i] != '0') cnt1++;
            if(i%2 == 1 && s[i] != '1') cnt1++;
            
            if(i%2 == 0 && s[i] != '1') cnt2++;
            if(i%2 == 1 && s[i] != '0') cnt2++;
        }
        return min(cnt1, cnt2);
    }
};

int main(int argc, char **argv)
{
    string s = "0100";
    Solution S;

    cout << S.minOperations(s);

    return 0;
}