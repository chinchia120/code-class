#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool checkIfExist(vector<int>& arr)
    {
        for(int i = 0; i < arr.size(); i++)
        {   
            if(arr[i] == 0)
            {
                int len = distance(arr.begin(), find(arr.begin(), arr.end(), 0));
                if(len != arr.size() && len != i) return true;
                else continue;
            }
            else
            {
                int len = distance(arr.begin(), find(arr.begin(), arr.end(), arr[i]*2));
                if(len != arr.size()) return true;
            }
        }
        return false;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {-2,0,10,-19,4,6,-8};
    Solution S;

    cout << S.checkIfExist(arr);

    return 0;
}