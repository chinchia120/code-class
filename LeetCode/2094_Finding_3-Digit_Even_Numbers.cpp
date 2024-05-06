#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class Solution
{
public:
    vector<int> findEvenNumbers(vector<int>& digits)
    {   
        sort(digits.begin(), digits.end());

        int prev = digits[0], cnt = 1;
        for(int i = 1; i < digits.size(); i++)
        {
            if(digits[i] == prev) cnt++;
            else
            {
                prev = digits[i];
                cnt = 1;
            }
            if(cnt > 3)
            {
                digits.erase(digits.begin()+i);
                i--;
            }

        }
        //show_1d_vector(digits);

        vector<int> _3digits;
        for(int i = 0; i < digits.size(); i++)
        {
            for(int j = 0; j < digits.size(); j++)
            {
                for(int k = 0; k < digits.size(); k++)
                {
                    if(i == j || i == k || j == k || digits[i] == 0 || digits[k]%2 == 1) continue;
                    int tmp = digits[i]*100+digits[j]*10+digits[k];
                    if(!CheckIsNumberExist(_3digits, tmp)) _3digits.push_back(tmp);
                }
            }
        }
        return _3digits;
    }

    bool CheckIsNumberExist(vector<int> vec, int num)
    {
        for(int tmp: vec) if(tmp == num) return true;
        return false;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> digits = {3,7,1,1,7,0,4,2,2,8,9,2,6,3,3,9,1,3,5,1,5,3,8,3,3,4,6,1,3,6,5,2,3,8,6,9,3,9,4,8,7,3,3,5,3,8,4,9,3,7,0,1,0,6,6,2,2,8,6,4,2,7,0,3,2,4,8,9,4,9,8,8,4,2,7,6,5,5,1,7,4,9,9,8,3,5,0,8,5,0,7,5,9,8,8,4,6,4,2,8};
    Solution S;

    S.show_1d_vector(S.findEvenNumbers(digits));

    return 0;
}