#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int hardestWorker(int n, vector<vector<int>>& logs)
    {
        int ID = logs[0][0], WorkTime = logs[0][1];
        for(int i = 1; i < logs.size(); i++)
        {
            if(logs[i][1]-logs[i-1][1] > WorkTime || (logs[i][1]-logs[i-1][1] == WorkTime && logs[i][0] < ID))
            {
                WorkTime = logs[i][1]-logs[i-1][1];
                ID = logs[i][0];
            }
        }
        return ID;
    }
};

int main(int argc, char **argv)
{
    int n = 10;
    vector<vector<int>> logs = {{0,3},{2,5},{0,9},{1,15}};
    Solution S;

    cout << S.hardestWorker(n, logs);

    return 0;
}