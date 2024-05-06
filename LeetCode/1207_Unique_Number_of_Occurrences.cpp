#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    bool uniqueOccurrences(vector<int>& arr)
    {
        sort(arr.begin(), arr.end());

        int prev = arr[0], cnt = 1;
        vector<int> list;
        for(int i = 1; i < arr.size(); i++)
        {
            if(arr[i] == prev) cnt++;
            else
            {   
                for(int j = 0; j < list.size(); j++)
                {
                    if(cnt == list[j]) return false;
                }
                list.push_back(cnt);
                cnt = 1;
                prev = arr[i]; 
            }
        }
        for(int i = 0; i < list.size(); i++)
        {
            if(cnt == list[i]) return false;
        }
        return true;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {-3,0,1,-3,1,1,1,-3,10,0};
    Solution S;

    cout << S.uniqueOccurrences(arr);

    return 0;
}