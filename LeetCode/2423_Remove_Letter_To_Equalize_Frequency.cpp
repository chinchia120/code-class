#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool equalFrequency(string word)
    {   
        vector<vector<int>> CharFres;
        for(char ch: word)
        {
            int flag = 0;
            for(int i = 0; i < CharFres.size(); i++)
            {
                if((int)ch == CharFres[i][1])
                {
                    flag = 1;
                    CharFres[i][0]++;
                    break;
                }
            }
            if(flag == 0)
            {
                CharFres.push_back(vector<int> ());
                CharFres[CharFres.size()-1].push_back(1);
                CharFres[CharFres.size()-1].push_back((int)ch);
            }
        }
        sort(CharFres.begin(), CharFres.end());

        int flag = 1;
        CharFres[CharFres.size()-1][0]--;
        for(int i = 1; i < CharFres.size(); i++)
        {
            if(i == CharFres.size()-1) if(CharFres[i][0] == 0) continue;
            if(CharFres[i][0]-CharFres[i-1][0] != 0)
            {
                flag = 0;
                break;
            }
        }
        CharFres[CharFres.size()-1][0]++;
        if(flag == 1) return true;

        CharFres[0][0]--;
        for(int i = 1; i < CharFres.size(); i++)
        {   
            if(i == 1 && CharFres[0][0] == 0) continue;
            if(CharFres[i][0]-CharFres[i-1][0] != 0) return false;
        }
        return true;
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
    string word = "abcc";
    Solution S;

    cout << S.equalFrequency(word);

    return 0;
}