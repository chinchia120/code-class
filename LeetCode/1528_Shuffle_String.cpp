#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string restoreString(string s, vector<int>& indices)
    {
        for(int i = 0; i < indices.size(); i++)
        {
            for(int j = i+1; j < indices.size(); j++)
            {
                if(indices[i] > indices[j])
                {
                    int tmp1 = indices[i];
                    indices[i] = indices[j];
                    indices[j] = tmp1;

                    char tmp2 = s[i];
                    s[i] = s[j];
                    s[j] = tmp2;
                }
            }
        }
        return s;
    }
};

int main(int argc, char **argv)
{   
    string s = "codeleet";
    vector<int> indices = {4,5,6,7,0,2,1,3};
    Solution S;

    cout << S.restoreString(s, indices);

    return 0;
}