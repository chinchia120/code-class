#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<string> findOcurrences(string text, string first, string second)
    {   
        vector<string> str_spt, str_third;
        str_spt = split_string(text, str_spt);

        for(int i = 2; i < str_spt.size(); i++)
        {
            if(str_spt[i-2] == first && str_spt[i-1] == second) str_third.push_back(str_spt[i]);
        }
        return str_third;
    }

    void show_1d_vector(vector<string> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }

    vector<string> split_string(string str, vector<string> vec)
    {
        string tmp = "";
        for(int i = 0; i < str.length(); i++)
        {
            if(!tmp.empty() && str[i] == ' ')
            {
                vec.push_back(tmp);
                tmp = "";
            }
            else
            {
                tmp.push_back(str[i]);
            }
        }
        vec.push_back(tmp);

        return vec;
    }
};

int main(int argc, char **argv)
{
    string text = "alice is a good girl she is a good student", first = "a", second = "good";
    Solution S;

    S.show_1d_vector(S.findOcurrences(text, first, second));

    return 0;
}