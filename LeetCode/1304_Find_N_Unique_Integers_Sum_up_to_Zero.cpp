#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> sumZero(int n)
    {
        vector<int> vec;
        int index = 0;
        for(int i = -n/2; i <= n/2; i++)
        {
            if(i == 0 && n%2 == 0) continue;
            vec.push_back(i);
        }
        return vec;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    int n = 4;
    Solution S;

    S.show_1d_vector(S.sumZero(n));

    return 0;
}