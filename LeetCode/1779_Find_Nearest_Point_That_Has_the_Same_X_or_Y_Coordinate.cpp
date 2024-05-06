#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

class Solution
{
public:
    int nearestValidPoint(int x, int y, vector<vector<int>>& points)
    {
        int minDis = INT32_MAX, minIndex = INT32_MAX;
        for(int i = 0; i < points.size(); i++)
        {
            if(points[i][0] == x || points[i][1] == y)
            {   
                if(minDis > abs(points[i][0]-x)+abs(points[i][1]-y))
                {
                    minDis = abs(points[i][0]-x)+abs(points[i][1]-y);
                    minIndex = i;
                }
                if(minDis == 0) break;
            }
        }

        if(minDis == INT32_MAX) return -1;
        else return minIndex; 
    }
};

int main(int argc, char **argv)
{
    int x = 3, y = 4;
    vector<vector<int>> points = {{1,2},{3,1},{2,4},{2,3},{4,4}};
    Solution S;

    cout << S.nearestValidPoint(x, y, points);

    return 0;
}