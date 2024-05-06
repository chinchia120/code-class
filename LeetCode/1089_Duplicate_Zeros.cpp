#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    void duplicateZeros(vector<int>& arr)
    {   
        int len = arr.size();
        for(int i = 0; i < len; i++)
        {
            if(arr[i] == 0)
            {
                arr.insert(arr.begin()+i, 0);
                arr.pop_back();
                i++;
            }
        }
        //show_1d_vector(arr);
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> arr = {1,0,2,3,0,4,5,0};
    Solution S;

    S.duplicateZeros(arr);

    return 0;
}