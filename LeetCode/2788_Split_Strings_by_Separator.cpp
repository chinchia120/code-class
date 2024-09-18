#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    vector<string> splitWordsBySeparator(vector<string>& words, char separator)
    {
        vector<string> words_spt;
        for (string word: words)
        {   
            string tmp = "";
            for (char ch: word)
            {
                if (ch == separator && tmp != "")
                {
                    words_spt.push_back(tmp);
                    tmp = "";
                }
                else if (ch != separator)
                {
                    tmp.push_back(ch);
                }
            }
            if (tmp != "") words_spt.push_back(tmp);
        }
        return words_spt;
    }
};