#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    string reorderSpaces(string text)
    {
        vector<string> str_spt = split_string(text);
        int space, extra;
        if(str_spt.size() == 2)
        {   
            extra = stoi(str_spt[1]);
            for(int j = 0; j < extra; j++) str_spt[0].push_back(' ');
            return str_spt[0];
        }
        else
        {
            space = stoi(str_spt.back())/(str_spt.size()-2);
            extra = stoi(str_spt.back())%(str_spt.size()-2);
            str_spt.pop_back();
        }
        
        string str = "";
        for(int i = 0; i < str_spt.size(); i++)
        {
            string tmp = str_spt[i];
            for(char ch: tmp) str.push_back(ch);
            if(i != str_spt.size()-1) for(int j = 0; j < space; j++) str.push_back(' ');
            else for(int j = 0; j < extra; j++) str.push_back(' ');
        }
        return str;
    }

    vector<string> split_string(string str)
    {
        vector<string> vec;
        string tmp = "";
        int cnt = 0;
        for(char ch: str)
        {   
            if(ch == ' ') cnt++;
            if(!tmp.empty() && ch == ' ')
            {   
                vec.push_back(tmp);
                tmp = "";
            }
            if(ch != ' ') tmp.push_back(ch);
        }
        if(!tmp.empty()) vec.push_back(tmp);
        vec.push_back(to_string(cnt));
        return vec;
    }
};

int main(int argc, char **argv)
{
    string text = "a";
    Solution S;

    cout << S.reorderSpaces(text);

    return 0;
}