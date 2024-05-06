#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> shortestToChar(string s, char c)
    {
        vector<int> ch_index = {}, min_dis = {};
        for(int i = 0; i < s.length(); i++)
        {
            if(s[i] == c) ch_index.push_back(i);
        }
        //show_vector(ch_index);

        for(int i = 0; i < s.length(); i++)
        {   
            int min = 9999;
            for(int j = 0; j < ch_index.size(); j++)
            {
                if(abs(i-ch_index[j]) < min)
                {
                    min = abs(i-ch_index[j]);
                    if(min == 0) break;
                }
            }
            min_dis.push_back(min);
        }

        return min_dis;
    }

    void show_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "loveleetcode";
    char c = 'e';
    Solution S;

    S.show_vector(S.shortestToChar(s, c));

    return 0;
}