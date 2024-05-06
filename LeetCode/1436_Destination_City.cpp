#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    string destCity(vector<vector<string>>& paths)
    {
        for(int i = 0; i < paths.size(); i++)
        {
            string cityB = paths[i][1];
            //cout << cityB << endl;
            int flag = 0;
            for(int j = 0; j < paths.size(); j++)
            {
                string cityA = paths[j][0];
                if(cityA == cityB)
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) return cityB;
        }
        return "0";
    }
};

int main(int argc, char **argv)
{
    vector<vector<string>> paths = {{"London","New York"}, {"New York","Lima"}, {"Lima","Sao Paulo"}};
    Solution S;

    cout << S.destCity(paths);

    return 0;
}