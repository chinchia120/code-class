#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int numDecodings(string s)
    {
        if(s.length() == 1 && s[0] != '0') return 1;
        if(s.length() == 1 && s[0] == '0') return 0;
        if(s.length() != 1 && s[0] == '0') return 0;

        vector<int> dp(s.length()+1, 0);
        dp[0] = 1;
        dp[1] = 1;
        for(int i = 2; i <= s.length(); i++)
        {
            int one = s[i-1] - '0', two = stoi(s.substr(i-2, 2));

            if(one != 0) dp[i] += dp[i-1];
            if(10 <= two && two <= 26) dp[i] += dp[i-2];
        }
        return dp[s.length()];
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "11106";
    Solution S;

    cout << S.numDecodings(s);

    return 0;
}