#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> decrypt(vector<int>& code, int k)
    {
        vector<int> vec (code.size(), 0);
        if(k > 0)
        {
            for(int i = 0; i < vec.size(); i++)
            {
                int sum = 0;
                for(int j = 1; j <= k; j++)
                {
                    int index = i+j;
                    if(index >= vec.size()) index -= vec.size();
                    sum += code[index];
                }
                vec[i] = sum;
            }
        }

        if(k < 0)
        {   
            for(int i = 0; i < vec.size(); i++)
            {
                int sum = 0;
                for(int j = k; j < 0; j++)
                {
                    int index = i+j;
                    if(index < 0) index += vec.size();
                    sum += code[index];
                }
                vec[i] = sum;
            }
        }
        return vec;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> code = {5,7,1,4};
    int k = 3;
    Solution S;

    S.show_1d_vector(S.decrypt(code, k));

    return 0;
}