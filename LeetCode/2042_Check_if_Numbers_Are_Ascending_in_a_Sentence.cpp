#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <unordered_set>
using namespace std;

class Solution
{
public:
    bool areNumbersAscending(string s)
    {
        vector<int> num;
        string str = "";
        for(char ch: s)
        {
            if(48 <= (int)ch && (int)ch <= 57) str.push_back(ch);
            else
            {
                if(!str.empty())
                {
                    num.push_back(stoi(str));
                    str = "";
                }
            }
        }
        if(!str.empty()) num.push_back(stoi(str));

        vector<int> numCopy = num;
        sort(num.begin(), num.end());
        unordered_set<int> numRemove (numCopy.begin(), numCopy.end());

        return (num == numCopy && numCopy.size() == numRemove.size())? true: false;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "hello world 5 x 5";
    Solution S;

    cout << S.areNumbersAscending(s);

    return 0;
}