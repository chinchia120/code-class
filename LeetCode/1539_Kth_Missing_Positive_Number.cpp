class Solution
{
public:
    int findKthPositive(vector<int>& arr, int k)
    {   
        int cnt = 0;
        while(k > 0)
        {   
            cnt++;
            if(cnt == arr[0]) arr.erase(arr.begin());
            else k--;
        }
        return cnt;
    }
};