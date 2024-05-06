#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int heightChecker(vector<int>& heights)
    {   
        vector<int> hei_copy = heights;
        sort(heights.begin(), heights.end());

        int cnt = 0;
        for(int i = 0; i < heights.size(); i++)
        {
            if(hei_copy[i] != heights[i]) cnt++;
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> heights = {1,1,4,2,1,3};
    Solution S;

    cout << S.heightChecker(heights);

    return 0;
}
