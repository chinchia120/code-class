#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maxDistance(vector<int>& colors)
    {   
        int maxDis = 1;
        for(int i = 0; i < colors.size(); i++)
        {
            for(int j = i+1; j < colors.size(); j++)
            {
                if(colors[i] != colors[j]) maxDis = max(maxDis, j-i);
            }
        }
        return maxDis;
    }
};