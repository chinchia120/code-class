#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool validPath(int n, vector<vector<int>>& edges, int source, int destination)
    {   
        vector<vector<int>> set;
        int index = 0;
        for(vector<int> edge: edges)
        {   
            int flag = 0;
            for(int i = 0; i < set.size(); i++)
            {
                for(int j = 0; j < set[i].size(); j++)
                {
                    if(edge[0] == set[i][j])
                    {   
                        flag = 1;
                        set[i].push_back(edge[1]);
                        break;
                    }

                    if(edge[1] == set[i][j])
                    {   
                        flag = 1;
                        set[i].push_back(edge[0]);
                        break;
                    }
                }
            }
            if(flag == 0) 
            {
                set.push_back(vector<int> ());
                set[index].push_back(edge[0]);
                set[index].push_back(edge[1]);
                index++;
            }
        }
        //show_2d_vector(set);
        
        for(int i = 0; i < set.size(); i++)
        {   
            int flag1 = 0, flag2 = 0;
            for(int j = 0; j < set[i].size(); j++)
            {
                if(set[i][j] == source) flag1 = 1;
                if(set[i][j] == destination) flag2 = 1;
            }
            if(flag1 == 1 && flag2 == 1) return true;
        }
        
        return (set.empty())? true: false;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(vector<int> nums: vec)
        {
            for(int num: nums) cout << num << " ";
            cout << endl;
        }
    }
};

int main(int argc, char **argv)
{
    int n = 3, source = 0, destination = 2;
    vector<vector<int>> edges = {{0,1},{1,2},{2,0}};
    Solution S;

    cout << S.validPath(n, edges, source, destination);
}