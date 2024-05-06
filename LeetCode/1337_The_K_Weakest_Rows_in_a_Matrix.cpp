#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> kWeakestRows(vector<vector<int>>& mat, int k)
    {
        vector<vector<int>> soldier (mat.size(), vector<int> (2, 0));
        for(int i = 0; i < mat.size(); i++)
        {   
            int cnt = 0;
            for(int j: mat[i])
            {
                if(j == 1) cnt++;
            }
            soldier[i][0] = i;
            soldier[i][1] = cnt;
        }
        //show_2d_vector(soldier);

        for(int i  = 0; i < soldier.size(); i++)
        {
            for(int j = i+1; j < soldier.size(); j++)
            {
                if((soldier[i][1] > soldier[j][1]) || (soldier[i][1] == soldier[j][1] && soldier[i][0] > soldier[j][0]))
                {
                    int tmp1 = soldier[i][0];
                    soldier[i][0] = soldier[j][0];
                    soldier[j][0] = tmp1;

                    int tmp2 = soldier[i][1];
                    soldier[i][1] = soldier[j][1];
                    soldier[j][1] = tmp2;
                }
            }
        }
        //show_2d_vector(soldier);

        vector<int> WeakestRow (k, 0);
        for(int i = 0; i < k; i++) WeakestRow[i] = soldier[i][0];

        return WeakestRow;
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
    vector<vector<int>> mat = {{1,1,0,0,0},{1,1,1,1,0},{1,0,0,0,0},{1,1,0,0,0},{1,1,1,1,1}};
    int k = 3;
    Solution S;

    S.show_1d_vector(S.kWeakestRows(mat, k));

    return 0;
}