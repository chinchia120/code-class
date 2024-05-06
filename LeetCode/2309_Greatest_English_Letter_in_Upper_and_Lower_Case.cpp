#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    string greatestLetter(string s)
    {
        vector<vector<int>> UpperLower (26, vector<int> (2, 0));
        for(char ch: s)
        {
            if(isupper(ch)) UpperLower[(int)ch-65][0]++;
            if(islower(ch)) UpperLower[(int)ch-97][1]++;
        }
        //Show2DVector(UpperLower);

        string tmp = "";
        for(int i = UpperLower.size()-1; i >= 0; i--)
        {   
            if(UpperLower[i][0] > 0 && UpperLower[i][1] > 0)
            {
                tmp.push_back((char)i+65);
                return tmp;
            }
        }
        return "";
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
    string s = "lEeTcOdE";
    Solution S;

    cout << S.greatestLetter(s);

    return 0;
}