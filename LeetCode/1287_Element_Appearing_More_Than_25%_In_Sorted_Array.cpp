#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int findSpecialInteger(vector<int>& arr)
    {   
        int cnt = 1 , check = arr[0];
        for(int i = 1; i < arr.size(); i++)
        {
            if(arr[i] == check)
            {
                cnt++;
                if(cnt > arr.size()/4) return arr[i];
            }
            else
            {
                check = arr[i];
                cnt = 1;
            }
        }
        return arr[0];
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {1,2,2,6,6,6,6,7,10};
    Solution S;

    cout << S.findSpecialInteger(arr);

    return 0;
}