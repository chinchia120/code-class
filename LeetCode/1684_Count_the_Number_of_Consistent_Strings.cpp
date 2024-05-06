#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countConsistentStrings(string allowed, vector<string>& words)
    {
        int cnt = 0;
        for(string word: words)
        {
            int flag2 = 1;
            for(char ch: word)
            {   
                int flag1 = 0;
                for(char allow: allowed)
                {   
                    if(ch == allow)
                    {
                        flag1 = 1;
                        break;
                    }
                }
                if(flag1 == 0)
                {
                    flag2 = 0;
                    break;
                }
            }
            if(flag2 == 1) cnt++;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    string allowed = "ab";
    vector<string> words = {"ad","bd","aaab","baa","badab"};
    Solution S;

    cout << S.countConsistentStrings(allowed, words);

    return 0;
}