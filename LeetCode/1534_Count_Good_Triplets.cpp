#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countGoodTriplets(vector<int>& arr, int a, int b, int c)
    {   
        int cnt = 0;
        for(int i = 0; i < arr.size(); i++)
        {
            for(int j = i+1; j < arr.size(); j++)
            {
                for(int k = j+1; k < arr.size(); k++)
                {
                    if(abs(arr[i]-arr[j]) <= a && abs(arr[j]-arr[k]) <= b && abs(arr[i]-arr[k]) <= c) cnt++;
                }
            }
        }
        return cnt;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {3,0,1,1,9,7};
    int a = 7, b = 2, c = 3;
    Solution S;

    cout << S.countGoodTriplets(arr, a, b, c);

    return 0;
}