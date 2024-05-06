#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int captureForts(vector<int>& forts)
    {
        int MaxLen = 0, index = 0, flag = 0;
        for(int i = 0; i < forts.size(); i++)
        {
            if(flag == 0 && (forts[i] == 1 || forts[i] == -1))
            {
                index = i;
                flag = 1;
            }
            else if(flag == 1 && forts[i] == -forts[index])
            {   
                MaxLen = max(MaxLen, i-index-1);
                index = i;
            }
            else if(flag == 1 && forts[i] == forts[index])
            {   
                index = i;
            }
        }
        return MaxLen;
    }
};

int main(int argc, char **argv)
{
    vector<int> forts = {1,0,0,-1,0,0,0,0,1};
    Solution S;

    cout << S.captureForts(forts);

    return 0;
}