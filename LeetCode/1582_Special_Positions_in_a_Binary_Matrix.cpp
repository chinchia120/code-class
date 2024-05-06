#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int numSpecial(vector<vector<int>>& mat)
    {
        //show_2d_vector(mat);

        int cnt = 0;
        for(int i = 0; i < mat.size(); i++)
        {
            for(int j = 0; j < mat[i].size(); j++)
            {
                if(mat[i][j] == 1)
                {   
                    int flag = 1;
                    for(int k = 0; k < mat.size(); k++)
                    {
                        for(int l = 0; l < mat[k].size(); l++)
                        {
                            if(k == i && l == j) continue;
                            if(k == i || l == j)
                            {
                                if(mat[k][l] == 1)
                                {
                                    flag = 0;
                                    break;
                                }
                            }
                        }
                    }
                    if(flag == 1) cnt++;
                }
            }
        }
        return cnt;
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
    vector<vector<int>> vec = {{1, 0, 0}, {0, 0, 1}, {1, 0 ,0}};
    Solution S;

    cout << S.numSpecial(vec);

    return 0;
}