#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string capitalizeTitle(string title)
    {
        vector<string> spts = SplitString(title);
        string Capitalize = "";
        for(string spt: spts)
        {
            if(spt.length() <= 2)
            {
                for(char ch: spt) Capitalize.push_back(tolower(ch));
            }
            else
            {
                for(int i = 0; i < spt.length(); i++)
                {
                    if(i == 0) Capitalize.push_back(toupper(spt[i]));
                    else Capitalize.push_back(tolower(spt[i]));
                }
            }
            Capitalize.push_back(' ');
        }
        Capitalize.pop_back();
        return Capitalize;
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
    string title = "First leTTeR of EACH Word";
    Solution S;

    cout << S.capitalizeTitle(title);

    return 0;
}