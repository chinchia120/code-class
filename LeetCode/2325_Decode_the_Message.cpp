#include <iostream>
using namespace std;

class Solution
{
public:
    string decodeMessage(string key, string message)
    {
        string SubstitutionTable = MakeSubstitutionTable(key), decode = "";
        for(char ch: message)
        {   
            if(ch != ' ')
            {
                for(int i = 0; i < SubstitutionTable.length(); i++)
                {   
                    if(ch == SubstitutionTable[i]) decode.push_back((char)i+97);
                }
            }
            else decode.push_back(' ');
        }
        return decode;
    }

    string MakeSubstitutionTable(string key)
    {
        string SubstitutionTable = "";
        for(char ch: key)
        {   
            if(ch == ' ') continue;
            else
            {
                int flag = 0;
                for(char word: SubstitutionTable)
                {
                    if(ch == word)
                    {
                        flag = 1;
                        break;
                    }
                }
                if(flag == 0) SubstitutionTable.push_back(ch);
            }
        }
        return SubstitutionTable;
    }
};

int main(int argc, char **argv)
{
    string key = " tzltslowpdugkobsgnptniaeloxlgeodlzrwropzysynkdusfqztmahphrcehvexfquudhqasqynxsazaqaklxmyshdiswjuvsckwv bzplbxhjqfkyhuxnzjcswk pluiecpgpmtoesuorztohzctlbecilccnv tyxmcvpfpdvjnabxkecwxztirsynjoanrqxkfpgctgvjhphntjxkev naljv tkxlzjwujps cjjaunfyorkukdevwgkoraujhbbahm faydklzh qykj hplak", message = "c aidfcxgplulnyupwuhjpargoiqdghpkbxoutjuxrlqwvuipwlwvzvbjchtyvuavbfmrejmlnmqxvanwhxjvjolkafekdlbvfxnuvnjmdwvuizdhortipiuabspmzgmcegmqrsumcveyzzazcarnjtmicskzsx hclsqpwskrakgvbiuswfy fsntlxgz fi";
    Solution S;

    cout << S.decodeMessage(key, message);

    return 0;
}