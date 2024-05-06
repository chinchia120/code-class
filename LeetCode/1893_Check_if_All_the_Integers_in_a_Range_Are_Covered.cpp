#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool isCovered(vector<vector<int>>& ranges, int left, int right)
    {
        for(int i = left; i <= right; i++)
        {
            int flag = 0;
            for(vector<int> range: ranges)
            {
                if(range[0] <= i && i <= range[1])
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) return false;
        }   
        return true;
    }
};

int main(int argc, char **argv)
{
    vector<vector<int>> ranges = {{1,2},{3,4},{5,6}};
    int left = 2, right = 5;
    Solution S;

    cout << S.isCovered(ranges, left, right);

    return 0;
}