#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool checkDistances(string s, vector<int>& distance)
    {
        vector<int> check (26, -1);
        for(int i = 0; i < check.size(); i++)
        {   
            int index1 = -1;
            for(int j = 0; j < s.length(); j++)
            {   
                cout << (int)s[j] << " " << i+97 << endl;
                if((int)s[j] == i+97 && index1 == -1) index1 = j;
                else if((int)s[j] == i+97 && index1 != -1)
                {
                    check[i] = j-index1-1;
                    break;
                }
            }
        }
        
        for(int i = 0; i < check.size(); i++)
        {
            if(check[i] != -1 && check[i] != distance[i]) return false; 
        }
        return true;
    }

    void Show1DVector(vector<int> nums)
    {
        for(int num: nums) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string s = "abaccb";
    vector<int> distance = {1,3,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    Solution S;

    cout << S.checkDistances(s, distance);

    return 0;
}