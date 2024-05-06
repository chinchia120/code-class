class Solution
{
public:
    int findTheDistanceValue(vector<int>& arr1, vector<int>& arr2, int d)
    {
        int cnt = 0;
        for(int num1: arr1)
        {   
            int flag = 0;
            for(int num2: arr2)
            {
                if(abs(num1-num2) <= d)
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) cnt++;
            
        }
        return cnt;
    }
};