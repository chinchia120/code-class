#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int canBeTypedWords(string text, string brokenLetters)
    {   
        int cnt = 0;
        vector<string> spt = split_string(text);
        for(string str: spt)
        {   
            int flag = 0;
            for(int i = 0; i < str.length(); i++)
            {
                for(int j = 0; j < brokenLetters.length(); j++)
                {
                    if(str[i] == brokenLetters[j])
                    {
                        flag = 1;
                        break;
                    }
                }
            }
            if(flag == 0) cnt++;
        }
        return cnt;
    }

    vector<string> split_string(string str)
    {
        vector<string> spt;
        
        string tmp = "";
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
    string text = "hello world", brokenLetters = "ad";
    Solution S;

    cout << S.canBeTypedWords(text, brokenLetters);

    return 0;
}