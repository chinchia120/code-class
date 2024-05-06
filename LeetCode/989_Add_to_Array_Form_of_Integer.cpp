#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    vector<int> addToArrayForm(vector<int>& num, int k)
    {   
        int carry = 0;
        for(int i = 0; i < num.size(); i++)
        {   
            int sum = num[num.size()-1-i] + k%10 + carry;

            num[num.size()-1-i] = sum % 10;
            carry = sum / 10;
            k /= 10;
        }

        while(k != 0)
        {   
            int sum = k%10 + carry;
            num.insert(num.begin(), sum%10);
            carry = sum / 10;
            k /= 10;
        }

        if(carry != 0) num.insert(num.begin(), carry);

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
    vector<int> num = {6};
    int k = 809;
    Solution S;

    S.show_1d_vector(S.addToArrayForm(num, k));

    return 0;
}