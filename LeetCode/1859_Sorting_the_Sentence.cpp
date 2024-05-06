#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    string sortSentence(string s)
    {
        vector<string> spt = split_string(s);
        string str = "";
        int index = 1;

        while(spt.size() != 0)
        {   
            for(int i = 0; i < spt.size(); i++)
            {
                if(spt[i].back()-'0' == index)
                {
                    spt[i].pop_back();
                    str += spt[i];
                    str.push_back(' ');
                    spt.erase(spt.begin()+i);
                    index++;
                    break;
                }
            }
        }
        str.pop_back();
        return str;
    }

    vector<string> split_string(string str)
    {
        string tmp = "";
        vector<string> spt;
        for(int i = 0; i < str.length(); i++)
        {
            if(str[i] != ' ') tmp.push_back(str[i]);
            else
            {
                if(!tmp.empty())
                {
                    spt.push_back(tmp);
                    tmp = "";
                }
            }

            if(i == str.length()-1)
            {
                if(!tmp.empty())
                {
                    spt.push_back(tmp);
                    tmp = "";
                }
            }
        }
        return spt;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(string str: vec) cout << str << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "is2 sentence4 This1 a3";
    Solution S;

    cout << S.sortSentence(s);

    return 0;
}