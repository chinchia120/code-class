#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int furthestBuilding(vector<int>& heights, int bricks, int ladders)
    {
        for(int i = 1; i < heights.size(); i++)
        {
            if(heights[i]-heights[i-1] > 0)
            {
                if(heights[i]-heights[i-1] <= bricks)
                {
                    bricks -= heights[i]-heights[i-1];
                }
                else if(ladders > 0)
                {
                    ladders -= 1;
                }
                else return i-1;
            }
        }
        return heights.size()-1;
    }
};