#include <iostream>
using namespace std;

class Solution
{
public:
    int maxRepeating(string sequence, string word)
    {   
        int maxLen = 0;
        for(int i = 0; i < sequence.length(); i++)
        {   
            int cnt = 0, index1 = i, index2 = 0; 
            if(sequence[i] == word[0])
            {   
                while(1)
                {   
                    //cout << index1 << " " << sequence[index1] << " " << index2 << " " << word[index2] << endl;
                    if(sequence[index1] == word[index2])
                    {
                        index1++;
                        index2++;
                    }
                    else
                    {
                        maxLen = max(maxLen, cnt);
                        break;
                    }

                    if(index2 == word.size())
                    {
                        index2 -= word.size();
                        cnt++;
                    }

                    if(index1 == sequence.size())
                    {
                        maxLen = max(maxLen, cnt);
                        break;
                    }
                }
                //i = index1-index2;
            }
        }
        return maxLen;
    }
};

int main(int argc, char **argv)
{
    string sequence = "aaabaaaabaaabaaaabaaaabaaaabaaaaba", word = "aaaba";
    Solution S;

    cout << S.maxRepeating(sequence, word);

    return 0;
}
