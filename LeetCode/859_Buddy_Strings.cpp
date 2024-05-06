#include <iostream>
#include <string>
#include <unordered_set>
using namespace std;

class Solution
{
public:
    bool buddyStrings(string s, string goal)
    {   
        unordered_set<char> set_s(s.begin(), s.end());
        unordered_set<char> set_goal(goal.begin(), goal.end());

        if(s.length() != goal.length()) return false;
        if(s == goal && set_s.size()<s.length()) return true;

        for(int i = 0; i < s.length(); i++)
        {   
            for(int j = i+1; j < s.length(); j++)
            {   
                string tmp = s;
                swap(tmp[i], tmp[j]);
                if(tmp == goal) return true;
            }
        }
        return false;
    }

    void show_unordered_set(unordered_set<char> set)
    {
        for(auto it: set) cout << it << " ";
        cout << '\n';
    }
};

int main(int argc, char **argv)
{
    string s = "abcd", goal = "cbad";
    Solution S;

    cout << S.buddyStrings(s, goal);

    return 0;
}