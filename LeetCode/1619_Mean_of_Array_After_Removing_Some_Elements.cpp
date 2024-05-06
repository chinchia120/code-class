#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    double trimMean(vector<int>& arr)
    {   
        sort(arr.begin(), arr.end());
        
        double sum = 0;
        int len = arr.size()*0.9;
        for(int i = arr.size()*0.05; i < arr.size()*0.95; i++) sum += arr[i];
        return sum/len;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {6,0,7,0,7,5,7,8,3,4,0,7,8,1,6,8,1,1,2,4,8,1,9,5,4,3,8,5,10,8,6,6,1,0,6,10,8,2,3,4};
    Solution S;

    cout << S.trimMean(arr);

    return 0;
}