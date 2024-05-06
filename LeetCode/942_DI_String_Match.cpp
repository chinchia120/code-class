#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> diStringMatch(string s)
    {
        vector<int> perm;
        int min = 0, max = s.length();
        if(s[0] == 'I')
        {
            perm.push_back(min);
            min++;
        }
        else
        {
            perm.push_back(max);
            max--;
        }

        for(int i = 0; i < s.length()-1; i++)
        {
            if(s[i] == 'I' && s[i+1] == 'I')
            {
                perm.push_back(min);
                min++;
            }
            else if(s[i] == 'I' && s[i+1] == 'D')
            {
                perm.push_back(max);
                max--;
            }
            else if(s[i] == 'D' && s[i+1] == 'D')
            {
                perm.push_back(max);
                max--;
            }
            else
            {
                perm.push_back(min);
                min++;
            }
        }
        perm.push_back(max);

        return perm;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "IDID";
    Solution S;

    S.show_1d_vector(S.diStringMatch(s));

    return 0;
}