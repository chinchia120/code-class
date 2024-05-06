#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    int findLeastNumOfUniqueInts(vector<int>& arr, int k)
    {
        vector<vector<int>> FreNums;
        for(int num: arr)
        {   
            int flag = 0;
            for(int i = 0; i < FreNums.size(); i++)
            {
                if(num == FreNums[i][1])
                {
                    flag = 1;
                    FreNums[i][0]++;
                    break;
                }
            }

            if(flag == 0)
            {
                FreNums.push_back(vector<int> ());
                FreNums[FreNums.size()-1].push_back(1);
                FreNums[FreNums.size()-1].push_back(num);
            }
        }

        sort(FreNums.begin(), FreNums.end());
        //Show2DVector(FreNums);

        int index = 0, cnt = 0;
        for(int i = 0; i < k; i++)
        {
            if(FreNums[index][0] > 0) FreNums[index][0]--;
            if(FreNums[index][0] == 0)
            {
                index++;
                cnt++;
            }
        }
        //Show2DVector(FreNums);

        return FreNums.size()-cnt;
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
    vector<int> arr = {4,3,1,1,3,3,2};
    int k = 3;
    Solution S;

    cout << S.findLeastNumOfUniqueInts(arr, k);

    return 0;
}