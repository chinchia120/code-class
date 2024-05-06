#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int similarPairs(vector<string>& words)
    {
        vector<vector<int>> lists;
        for(string word: words)
        {
            lists.push_back(CheckChar(word));
            sort(lists[lists.size()-1].begin(), lists[lists.size()-1].end());
        }
        //Show2DVector(lists);

        int cnt = 0;
        for(int i = 0; i < lists.size(); i++)
        {
            for(int j = i+1; j < lists.size(); j++)
            {
                if(lists[i] == lists[j]) cnt++;
            }
        }
        return cnt;
    }

    vector<int> CheckChar(string word)
    {
        vector<int> list;
        for(char ch: word)
        {
            int flag = 0;
            for(int i = 0; i < list.size(); i++)
            {
                if((int)ch == list[i])
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) list.push_back((int)ch);
        }
        return list;
    }

    void Show2DVector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<string> words = {"aba","aabb","abcd","bac","aabc"};
    Solution S;

    cout << S.similarPairs(words);

    return 0;
}