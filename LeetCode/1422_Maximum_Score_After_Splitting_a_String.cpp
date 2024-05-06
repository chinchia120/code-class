#include <iostream>
using namespace std;

class Solution
{
public:
    int maxScore(string s)
    {   
        int cnt_zero = 0, cnt_one = 0, max_score = 0;
        for(int i = 0; i < s.length()-1; i++)
        {       
            cnt_zero = 0, cnt_one = 0;
            for(int j = 0; j <= i; j++)
            {
                if(s[j] == '0') cnt_zero++;
            }
            for(int j = s.length()-1; j >= i+1; j--)
            {
                if(s[j] == '1') cnt_one++;
            }
            max_score = max(max_score, cnt_one+cnt_zero);
        }
        return max_score;
    }
};

int main(int argc, char **argv)
{
    string s = "00";
    Solution S;

    cout << S.maxScore(s);

    return 0; 
}