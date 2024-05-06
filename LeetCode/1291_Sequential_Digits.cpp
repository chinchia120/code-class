#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    vector<int> sequentialDigits(int low, int high)
    {   
        string strlow = to_string(low), strhigh = to_string(high);

        vector<int> sequential;
        for(int i = strlow.length(); i <= strhigh.length(); i++)
        {
           for(int j = 1; j < 11-i; j++)
           {    
                string tmp = "";
                for(int k = j; k < j+i; k++) tmp.push_back(k+'0');
                if(low <= stoi(tmp) && stoi(tmp) <= high) sequential.push_back(stoi(tmp));
                if(high < stoi(tmp)) return sequential;
           }
        }
        return sequential;
    }

    void Show1DVector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    int low = 100, high = 3000;
    Solution S;

    S.Show1DVector(S.sequentialDigits(low, high));

    return 0;
}