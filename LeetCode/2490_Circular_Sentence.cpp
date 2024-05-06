#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool isCircularSentence(string sentence)
    {
        vector<string> spt = SplitString(sentence);
        if(spt.size() == 1)
        {
            if(spt[0][0] == spt[0].back()) return true;
            else return false;
        }
        else
        {
            for(int i = 0; i < spt.size()-1; i++)
            {
                if(spt[i].back() != spt[i+1][0]) return false;
            }
            if(spt[0][0] != spt[spt.size()-1].back()) return false;
        }
        return true;
    }

    vector<string> SplitString(string sentence)
    {
        string tmp = "";
        vector<string> spt;
        for(char ch: sentence)
        {
            if(ch != ' ') tmp.push_back(ch);
            else if(ch == ' ' && !tmp.empty())
            {
                spt.push_back(tmp);
                tmp = "";
            }
        }
        if(!tmp.empty()) spt.push_back(tmp);

        return spt;
    }

    void Show1DVector(vector<string> strs)
    {
        for(string str: strs) cout << str << " ";
        cout << endl;
    }
};