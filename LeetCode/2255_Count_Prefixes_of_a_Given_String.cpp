#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int countPrefixes(vector<string>& words, string s)
    {
        int cnt = 0;
        for(string word: words)
        {
            if(word.length() <= s.length())
            {
                if(word.substr(0, word.length()) == s.substr(0, word.length())) cnt++;
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<string> words = {"a","b","c","ab","bc","abc"};
    string s = "abc";
    Solution S;

    cout << S.countPrefixes(words, s);

    return 0;
}