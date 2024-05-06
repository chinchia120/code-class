#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    string reformatNumber(string number)
    {   
        string str = "", spt = split_string(number);
        if(spt.length()%3 == 0) 
        {
            for(int i = 0; i < spt.length(); i++)
            {
                str.push_back(spt[i]);
                if(i%3 == 2) str.push_back('-');
            }
        }
        if(spt.length()%3 == 1)
        {
            for(int i = 0; i < spt.length()-4; i++)
            {
                str.push_back(spt[i]);
                if(i%3 == 2) str.push_back('-');
            }
            str.push_back(spt[spt.length()-4]);
            str.push_back(spt[spt.length()-3]);
            str.push_back('-');
            str.push_back(spt[spt.length()-2]);
            str.push_back(spt[spt.length()-1]);
        }
        if(spt.length()%3 == 2)
        {
            for(int i = 0; i < spt.length()-2; i++)
            {
                str.push_back(spt[i]);
                if(i%3 == 2) str.push_back('-');
            }
            str.push_back(spt[spt.length()-2]);
            str.push_back(spt[spt.length()-1]);
        }
        if(str.back() == '-') str.pop_back();
        return str;
    }

    string split_string(string str)
    {
        string tmp = "";
        for(int ch: str) if(ch != ' ' && ch != '-') tmp.push_back(ch);
        return tmp;
    }
};

int main(int argc, char **argv)
{
    string number = "1-23-45 67890";
    Solution S;

    cout << S.reformatNumber(number);

    return 0;
}