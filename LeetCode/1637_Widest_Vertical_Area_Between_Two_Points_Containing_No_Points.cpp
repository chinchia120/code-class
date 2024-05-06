#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int maxWidthOfVerticalArea(vector<vector<int>>& points)
    {
        sort(points.begin(), points.end());

        int max_width = 0;
        for(int i = 0; i < points.size()-1; i++)
        {
            max_width = max(max_width, points[i+1][0]-points[i][0]);
        }

        return max_width;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(int i = 0; i< vec.size(); i++)
        {
            for(int j = 0; j < vec[i].size(); j++) cout << vec[i][j] << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> points = {{8,7}, {9,9}, {7,4}, {9,7}};
    Solution S;

    cout << S.maxWidthOfVerticalArea(points);

    return 0;
}