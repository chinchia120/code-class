#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool validMountainArray(vector<int>& arr)
    {   
        int flag = 1, peak = 0, inc = 0, dec = 0;
        for(int i = 0; i < arr.size()-1; i++)
        {
            if(arr[i+1] == arr[i])
            {
                return false;
            }
            else if(arr[i+1]-arr[i] > 0)
            {
                peak = max(peak, arr[i+1]);
                inc = 1;
                if(dec == 1) return false;
            }
            else if(arr[i+1]-arr[i] < 0 && arr[i] <= peak)
            {
                dec = 1;
                continue;
            }
            else 
            {
                return false;
            }
        }
        
        if(inc == 1 && dec == 1) return true;
        else return false;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {3,5,5};
    Solution S;

    cout << S.validMountainArray(arr);

    return 0;
}