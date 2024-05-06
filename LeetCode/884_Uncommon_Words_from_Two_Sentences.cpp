#include <iostream>
#include <vector>
#include <cstring>
using namespace std;

class Solution
{
public:
    vector<string> uncommonFromSentences(string s1, string s2)
    {
        vector<string> str1, str2, str3;
        str1 = split_string(s1, str1);
        str2 = split_string(s2, str2);

        for(int i = 0; i < str1.size(); i++)
        {   
            int flag = 0;
            for(int j = 0; j < str2.size(); j++)
            {
                if(str1[i] == str2[j])
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) str3.push_back(str1[i]);
        }
        return str3;
    }

    vector<string> split_string(string str, vector<string> vec)
    {   
        string tmp = "";
        for(int i = 0; i < str.length(); i++)
        {
            if((str[i] == ' ' && !tmp.empty()))
            {
                vec.push_back(tmp);
                tmp = "";
            }
            else tmp.push_back(str[i]);
        }
        if(!tmp.empty()) vec.push_back(tmp);

        return vec;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char ** argv)
{
    string s1 = "this apple is sweet", s2 = "this apple is sour";
    Solution S;

    S.show_1d_vector(S.uncommonFromSentences(s1, s2));

    return 0;
}