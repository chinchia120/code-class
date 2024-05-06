#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string firstPalindrome(vector<string>& words)
    {
        for(string word: words)
        {
            if(IsPalindromicString(word)) return word;
        }
        return "";
    }

    bool IsPalindromicString(string str)
    {   
        for(int i = 0; i < str.length()/2; i++)
        {
            if(str[i] != str[str.length()-1-i]) return false;
        }
        return true;
    }
};