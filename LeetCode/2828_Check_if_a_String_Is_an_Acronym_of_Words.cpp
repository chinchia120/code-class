#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    bool isAcronym(vector<string>& words, string s)
    {
        if (words.size() != s.length()) return false;

        for (int i = 0; i < words.size(); i++)
        {   
            string word = words[i];
            if (s[i] != word[0]) return false;
        }
        return true;
    }
};