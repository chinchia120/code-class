#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int mostWordsFound(vector<string>& sentences)
    {
        int maxLen = 0;
        for(string sentence: sentences)
        {   
            maxLen = max(maxLen, (int)SplitString(sentence).size());
        }
        return maxLen;
    }

    vector<string> SplitString(string str)
    {
        string tmp = "";
        vector<string> spt;
        for(char ch: str)
        {
            if(ch != ' ') tmp.push_back(ch);
            else
            {
                if(!tmp.empty()) spt.push_back(tmp);
                tmp = "";
            }
        }
        if(!tmp.empty()) spt.push_back(tmp);
        
        return spt;
    }
};

int main(int argc, char **argv)
{
    vector<string> sentences = {"alice and bob love leetcode","i think so too","this is great thanks very much"};
    Solution S;

    cout << S.mostWordsFound(sentences);

    return 0;
}