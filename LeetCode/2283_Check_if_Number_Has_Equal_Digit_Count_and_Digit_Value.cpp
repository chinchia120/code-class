#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool digitCount(string num)
    {
        vector<int> Count (10, 0);
        for(char ch: num) Count[ch-'0']++;
        //Show1DVector(Count);
        for(int i = 0; i < num.length(); i++)
        {
            if(num[i]-'0' != Count[i]) return false;
        }
        return true;
    }

    void Show1DVector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string num = "1210";
    Solution S;

    cout << S.digitCount(num);

    return 0;
}