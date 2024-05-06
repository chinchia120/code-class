#include <iostream>
using namespace std;

class Solution
{
public:
    string truncateSentence(string s, int k)
    {   
        string str = "";
        for(char ch: s)
        {
            if(ch == ' ') k--;
            if(k == 0) return str;
            str.push_back(ch);
        }
        return str;
    }
};

int main(int argc, char **argv)
{
    string s = "What is the solution to this problem";
    int k = 4;
    Solution S;

    cout << S.truncateSentence(s, k);

    return 0;
}