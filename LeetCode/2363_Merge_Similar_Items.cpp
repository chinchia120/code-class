#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<vector<int>> mergeSimilarItems(vector<vector<int>>& items1, vector<vector<int>>& items2)
    {
        //sort(items1.begin(), items1.end());
        //sort(items2.begin(), items2.end());

        for(int i = 0; i < items1.size(); i++)
        {
            for(int j = 0; j < items2.size(); j++)
            {
                if(items1[i][0] == items2[j][0])
                {
                    items1[i][1] += items2[j][1];
                    items2[j].clear();
                    break;
                }
            }
        }

        vector<vector<int>> res = items1;
        for(vector<int> vec: items2)
        {   
            if(vec.empty()) continue;
            res.push_back(vec);
        }
        sort(res.begin(), res.end());
        return res;
    }

    void Show2DVector(vector<vector<int>> vec)
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
    vector<vector<int>> items1 = {{1,1},{4,5},{3,8}}, items2 = {{3,1},{1,5}};
    Solution S;

    S.Show2DVector(S.mergeSimilarItems(items1, items2));
    
    return 0;
}