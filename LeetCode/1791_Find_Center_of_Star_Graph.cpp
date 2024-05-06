#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int findCenter(vector<vector<int>>& edges)
    {
        return (edges[0][0] == edges[1][0])? edges[0][0]: (edges[0][0] == edges[1][1])? edges[0][0]: edges[0][1];
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> edges  = {{1,2},{5,1},{1,3},{1,4}};
    Solution S;

    cout << S.findCenter(edges);

    return 0;
}