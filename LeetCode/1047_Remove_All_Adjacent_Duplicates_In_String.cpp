#include <iostream>
using namespace std;

class Solution
{
public:
    string removeDuplicates(string s)
    {   
        string rem = "";
        rem.push_back(s[0]);
        for(int i = 1; i < s.length(); i++)
        {
            if(!rem.empty() && rem.back() == s[i]) rem.pop_back();
            else rem.push_back(s[i]);
        }
        return rem;
    }
};

int main(int argc, char **argv)
{
    string s = "abbaca";
    Solution S;

    cout << S.removeDuplicates(s);

    return 0;
}