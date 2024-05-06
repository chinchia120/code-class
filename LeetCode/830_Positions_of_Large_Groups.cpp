#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> largeGroupPositions(string s)
    {
        vector<vector<int>> group2d;
        char str = s[0];
        int cnt = 1, index = 0;
        for(int i = 1; i < s.length(); i++)
        {   
            char tmp = s[i];
            if(tmp == str)
            {
                cnt++;

                if(i == s.length()-1 && cnt >= 3)
                {
                    group2d.push_back(vector<int> ()); 
                    group2d[index].push_back(i-cnt+1);
                    group2d[index].push_back(i);
                }
            }
            else if(tmp != str)
            {   
                if(cnt >= 3)
                {   
                    group2d.push_back(vector<int> ());
                    group2d[index].push_back(i-cnt);
                    group2d[index].push_back(i-1);
                    index++;
                }
                str = s[i];
                cnt = 1;
            }
        }
        return group2d;
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
    string s = "aaa";
    Solution S;

    S.show_2d_vector(S.largeGroupPositions(s));

    return 0;
}