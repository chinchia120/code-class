#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool isPrefixString(string s, vector<string>& words)
    {
        string str = "";
        for(int i = 0; i < words.size(); i++)
        {   
            string tmp = words[i];
            for(char ch: tmp) str.push_back(ch);

            if(s == str) return true;
        }
        return false;
    }
};

int main(int argc, char **argv)
{
    string s = "iloveleetcode";
    vector<string> words = {"i","love","leetcode","apples"};
    Solution S;

    cout << S.isPrefixString(s, words);

    return 0;
}