#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool isPathCrossing(string path)
    {
        int x = 0, y = 0, index = 1;
        vector<vector<int>> coor = {{x, y}};
        for(int i = 0; i < path.length(); i++)
        {
            if(path[i] == 'N') y++;
            if(path[i] == 'S') y--;
            if(path[i] == 'E') x++;
            if(path[i] == 'W') x--;

            for(int j = 0; j < coor.size(); j++)
            {   
                if(coor[j][0] == x && coor[j][1] == y) return true;
            }
            coor.push_back(vector<int> ());
            coor[index].push_back(x);
            coor[index].push_back(y);
            index++;
        }
        return false;
    }
};

int main(int argc, char **argv)
{
    string path = "NES";
    Solution S;

    cout << S.isPathCrossing(path);

    return 0;
}