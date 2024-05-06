#include <iostream>
using namespace std;

class Solution
{
public:
    int minimumRecolors(string blocks, int k)
    {
        int minCnt = INT32_MAX, cnt = 0;
        for(int i = 0; i < blocks.length()-k+1; i++)
        {
            if(i == 0) 
            {
                for(int j = 0; j < k; j++) if(blocks[j] == 'W') cnt++;
            }
            else
            {
                if(blocks[i-1] == 'W') cnt--;
                if(blocks[i+k-1] == 'W') cnt++;
            }
            minCnt = min(minCnt, cnt);
        }
        return minCnt;
    }
};

int main(int argc, char **argv)
{
    string blocks = "WBBWWBBWBW";
    int k = 7;
    Solution S;

    cout << S.minimumRecolors(blocks, k);

    return 0;
}