#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    bool checkIfPangram(string sentence)
    {
        vector<int> check (26, 1), sen(26, 0);
        for(char ch: sentence) sen[(int)ch-97] = 1;
        return (check == sen)? true: false;
    }
};

int main(int argc, char **argv)
{
    string sentence = "thequickbrownfoxjumpsoverthelazydog";
    Solution S;

    cout << S.checkIfPangram(sentence);

    return 0;
}