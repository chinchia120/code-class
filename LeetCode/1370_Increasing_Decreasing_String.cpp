#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

class Solution
{
public:
    string sortString(string s)
    {
        vector<vector<int>> ch_cnt = {{(int)s[0], 1}};
        int index = 1;
        for(int i = 1; i < s.length(); i++)
        {   
            int flag = 0;
            for(int j = 0; j < ch_cnt.size(); j++)
            {
                if(ch_cnt[j][0] == (int)s[i])
                {
                    flag = 1;
                    ch_cnt[j][1]++;
                    break;
                }
            }
            if(flag == 0)
            {
                ch_cnt.push_back(vector<int> ());
                ch_cnt[index].push_back((int)s[i]);
                ch_cnt[index].push_back((1));
                index++;
            }
        }
        //show_2d_vector(ch_cnt);
        sort(ch_cnt.begin(), ch_cnt.end());

        string str = "";
        while(str.length() != s.length())
        {
            for(int i = 0; i < ch_cnt.size(); i++)
            {
                if(ch_cnt[i][1] != 0)
                {
                    str.push_back((char)ch_cnt[i][0]);
                    ch_cnt[i][1]--;
                }
            }
            for(int i = ch_cnt.size()-1; i >= 0; i--)
            {
                if(ch_cnt[i][1] != 0)
                {
                    str.push_back((char)ch_cnt[i][0]);
                    ch_cnt[i][1]--;
                }
            }
        }
        return str;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(int i = 0; i < vec.size(); i++)
        {
            for(int j = 0; j < vec[i].size(); j++) cout << vec[i][j] << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    string s = "aaaabbbbcccc";
    Solution S;

    cout << S.sortString(s);

    return 0;
}