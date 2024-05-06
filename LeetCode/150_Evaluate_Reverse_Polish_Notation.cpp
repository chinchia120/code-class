#include <iostream>
#include <vector>
#include <string>
using namespace std;

class Solution
{
public:
    int evalRPN(vector<string>& tokens)
    {
        vector<int> calculate;
        for(string token: tokens)
        {   
            if(token == "+" || token == "-" || token == "*" || token == "/")
            {
                if(token == "+") calculate.push_back(calculate[calculate.size()-2]+calculate[calculate.size()-1]);
                if(token == "-") calculate.push_back(calculate[calculate.size()-2]-calculate[calculate.size()-1]);
                if(token == "*") calculate.push_back(calculate[calculate.size()-2]*calculate[calculate.size()-1]);
                if(token == "/") calculate.push_back(calculate[calculate.size()-2]/calculate[calculate.size()-1]);

                calculate.erase(calculate.end()-2);
                calculate.erase(calculate.end()-2);
            }
            else calculate.push_back(stoi(token));

            //Show1DVector(calculate);
        }
        return calculate.back();
    }

    void Show1DVector(vector<int> vec)
    {
        for(int num: vec) cout << num << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    vector<string> tokens = {"4","13","5","/","+"};
    Solution S;

    cout << S.evalRPN(tokens);

    return 0;
}