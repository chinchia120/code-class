#include <iostream>
#include <cmath>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<vector<int>> allCellsDistOrder(int rows, int cols, int rCenter, int cCenter)
    {   
        vector<vector<int>> coor;
        vector<int> dis;
        int index = 0;
        for(int i = 0; i < rows; i++)
        {   
            for(int j = 0; j < cols; j++)
            {
                dis.push_back(abs(i-rCenter) + abs(j-cCenter));
                
                coor.push_back(vector<int> ());
                coor[index].push_back(i);
                coor[index].push_back(j);
                index++;
            }
        }
        
        for(int i = 0; i < dis.size(); i++)
        {
            for(int j = i+1; j < dis.size(); j++)
            {
                if(dis[i] > dis[j])
                {
                    int tmp_dis = dis[i];
                    dis[i] = dis[j];
                    dis[j] = tmp_dis;

                    int tmp_row1 = coor[i][0], tmp_col1 = coor[i][1];
                    coor[i][0] = coor[j][0];
                    coor[i][1] = coor[j][1];
                    coor[j][0] = tmp_row1;
                    coor[j][1] = tmp_col1;
                }
            }
        }
        return coor;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(int i = 0; i < vec.size(); i++)
        {
            for(int j = 0; j < vec[i].size(); j++) cout << vec[i][j] << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    int rows = 1, cols = 2, rCenter = 0, cCenter = 0;
    Solution S;

    S.show_2d_vector(S.allCellsDistOrder(rows, cols, rCenter, cCenter));

    return 0;
}