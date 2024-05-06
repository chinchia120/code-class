#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<string> sortPeople(vector<string>& names, vector<int>& heights)
    {
        for(int i = 0; i < heights.size(); i++)
        {
            for(int j = i+1; j < heights.size(); j++)
            {
                if(heights[i] < heights[j])
                {
                    int tmp1 = heights[i];
                    heights[i] = heights[j];
                    heights[j] = tmp1;

                    string tmp2 = names[i];
                    names[i] = names[j];
                    names[j] = tmp2;
                }
            }
        }
        return names;
    }
};