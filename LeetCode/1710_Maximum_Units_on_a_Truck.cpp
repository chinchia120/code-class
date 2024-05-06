#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maximumUnits(vector<vector<int>>& boxTypes, int truckSize)
    {   
        for(int i = 0; i < boxTypes.size(); i++)
        {
            for(int j = i+1; j < boxTypes.size(); j++)
            {
                if(boxTypes[i][1] < boxTypes[j][1])
                {
                    int tmp1 = boxTypes[i][0];
                    boxTypes[i][0] = boxTypes[j][0];
                    boxTypes[j][0] = tmp1;

                    int tmp2 = boxTypes[i][1];
                    boxTypes[i][1] = boxTypes[j][1];
                    boxTypes[j][1] = tmp2;
                }
            }
        }

        int sum = 0;
        for(int i = 0; i < boxTypes.size(); i++)
        {
            if(boxTypes[i][0] > truckSize)
            {
                sum += truckSize*boxTypes[i][1];
                break;
            }
            else
            {
                sum += boxTypes[i][0]*boxTypes[i][1];
                truckSize -= boxTypes[i][0];
            }
        }
        return sum;
    }

    void shoe_2d_vector(vector<vector<int>> vec)
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
    vector<vector<int>> boxTypes = {{5,10},{2,5},{4,7},{3,9}};
    int truckSize = 10;  
    Solution S;

    cout << S.maximumUnits(boxTypes, truckSize);

    return 0;
}