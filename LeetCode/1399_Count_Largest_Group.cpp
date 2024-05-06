#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int countLargestGroup(int n)
    {   
        int cnt = 0, maxCnt = 0;
        vector<int> sum_cnt (36, 0);
        for(int i = 1; i <= n; i++)
        {
            string str = to_string(i);
            int sum = 0;
            for(char ch: str) sum += (int)ch-48;
            sum_cnt[sum-1]++;
            maxCnt = max(maxCnt, sum_cnt[sum-1]);
        }
        //show_1d_vector(sum_cnt);

        for(int num: sum_cnt) if(num == maxCnt) cnt++;
        return cnt;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << endl;
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    int n = 1111;
    Solution S;

    cout << S.countLargestGroup(n);

    return 0;
}