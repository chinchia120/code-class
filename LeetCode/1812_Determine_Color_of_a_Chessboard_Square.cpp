#include <iostream>
using namespace std;

class Solution
{
public:
    bool squareIsWhite(string coordinates)
    {   
        return ((int)coordinates[0]%2 != (coordinates[1]-'0')%2)? true: false;
    }
};

int main(int argc, char **argv)
{
    string coordinates = "c7";
    Solution S;

    cout << S.squareIsWhite(coordinates);

    return 0;
}