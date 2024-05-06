#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countGoodRectangles(vector<vector<int>>& rectangles)
    {
        vector<vector<int>> len_cnt;
        int index = 0;
        for(vector<int> rectangle: rectangles)
        {
            int flag = 0, minLen = min(rectangle[0], rectangle[1]);
            for(int i = 0; i < len_cnt.size(); i++)
            {
                if(len_cnt[i][0] == minLen)
                {   
                    flag = 1;
                    len_cnt[i][1]++;
                    break;
                }
            }
            if(flag == 0)
            {
                len_cnt.push_back(vector<int> ());
                len_cnt[index].push_back(minLen);
                len_cnt[index].push_back(1);
                index++;
            }
        }

        int maxLen = 0, maxCnt = 0 ;
        for(vector<int> vec: len_cnt)
        {
            if(maxLen < vec[0])
            {
                maxLen = vec[0];
                maxCnt = vec[1];
            }
        }
        return maxCnt;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> rectangles = {{5,8},{3,9},{5,12},{16,5}};
    Solution S;

    cout << S.countGoodRectangles(rectangles);

    return 0;
}