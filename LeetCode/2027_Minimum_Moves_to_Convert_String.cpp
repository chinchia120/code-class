#include <iostream>
using namespace std;

class Solution
{
public:
    int minimumMoves(string s)
    {
        int cnt = 0;
        for(int i = 0; i < s.length(); i++)
        {   
            if(s[i] == 'X')
            {
                cnt++;
                i += 2;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    string s = "XXOX";
    Solution S;

    cout << S.minimumMoves(s);

    return 0;
}