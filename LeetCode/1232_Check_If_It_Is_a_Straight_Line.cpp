#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool checkStraightLine(vector<vector<int>>& coordinates)
    {   
        if(coordinates.size() == 2) return true;

        int x1 = coordinates[0][0], y1 = coordinates[0][1];
        int x2 = coordinates[1][0], y2 = coordinates[1][1];
        int dy = y2-y1, dx = x2-x1, cont = dy*x1 - dx*y1;

        for(int i = 2; i < coordinates.size(); i++)
        {
            if(dy*coordinates[i][0]-dx*coordinates[i][1] != cont) return false;
        }
        return true;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> coordinates = {{1,2},{2,3},{3,4},{4,5},{5,6},{6,7}};
    Solution S;

    cout << S.checkStraightLine(coordinates);

    return 0;
}