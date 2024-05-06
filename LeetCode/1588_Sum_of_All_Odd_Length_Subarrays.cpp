#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int sumOddLengthSubarrays(vector<int>& arr)
    {   
        vector<int> cnt;
        for(int i = 1; i <= arr.size(); i+=2) cnt.push_back(i);
        int sum = 0, index_cnt = 0;
        for(int i = arr.size()-1; i >= 0; i-=2)
        {   
            for(int j = 0; j <= i; j++)
            {   
                for(int k = j; k < j+cnt[index_cnt]; k++) sum += arr[k];
            }
            index_cnt++;
        }
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {1,4,2,5,3};
    Solution S;

    cout << S.sumOddLengthSubarrays(arr);

    return 0;
}