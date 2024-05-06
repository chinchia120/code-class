#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> decode(vector<int>& encoded, int first)
    {
        vector<int> code (encoded.size()+1, first);
        for(int i = 1; i < code.size(); i++) code[i] = code[i-1]^encoded[i-1];
        return code;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<int> encoded = {6,2,7,3};
    int first = 4;
    Solution S;

    S.show_1d_vector(S.decode(encoded, first));

    return 0;
}