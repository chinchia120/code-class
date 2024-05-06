#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> getNoZeroIntegers(int n)
    {
        vector<int> num(2, 0);
        for(int i = 1; i < n; i++)
        {
            num[0] = i;
            num[1] = n-i;
            string str1 = to_string(num[0]), str2 = to_string(num[1]);

            int flag = 0;
            for(char c: str1)
            {
                if(c == '0')
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 1) continue;

            flag = 0;
            for(char c: str2)
            {
                if(c == '0')
                {
                    flag = 1;
                    break;
                }
            }
            if(flag == 0) break;
        }
        return num;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    int n = 1010;
    Solution S;

    S.show_1d_vector(S.getNoZeroIntegers(n));

    return 0;
}