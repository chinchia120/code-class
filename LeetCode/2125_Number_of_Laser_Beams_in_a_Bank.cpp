#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int numberOfBeams(vector<string>& bank)
    {   
        vector<int> laser_num;
        for(int i = 0; i < bank.size(); i++)
        {
            string laser = bank[i];
            int cnt = 0;
            for(char c: laser)
            {
                if(c == '1') cnt++;
            }
            if(cnt != 0) laser_num.push_back(cnt);
        }
        if(laser_num.size() < 2 ) return 0;

        int sum = 0;
        for(int i = 0; i < laser_num.size()-1; i++) sum += laser_num[i]*laser_num[i+1];
        
        return sum;
    }
};

int main(int argc, char **argv)
{
    vector<string> bank = {"011001","000000","010100","001000"};
    Solution S;

    cout << S.numberOfBeams(bank);

    return 0;
}