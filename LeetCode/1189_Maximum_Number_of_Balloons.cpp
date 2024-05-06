#include <iostream>
#include <vector>
using namespace std;

class Solution
{
public:
    int maxNumberOfBalloons(string text)
    {   
        vector<char> balloon = {'b', 'a', 'l', 'o', 'n'};
        vector<int> cnt(5, 0);
        for(int i = 0; i < text.length(); i++)
        {   
            if(text[i] == 'b') cnt[0]++;
            if(text[i] == 'a') cnt[1]++;
            if(text[i] == 'l') cnt[2]++;
            if(text[i] == 'o') cnt[3]++;
            if(text[i] == 'n') cnt[4]++;
        }
        //show_1d_vector(cnt);

        int min_cnt = 999999;
        for(int i = 0; i < cnt.size(); i++)
        {   
            if(i == 2 || i == 3) min_cnt = min(min_cnt, cnt[i]/2);
            else min_cnt = min(min_cnt, cnt[i]);
        }

        return min_cnt;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << " ";
        cout << endl;
    }
};

int main(int argc, char **argv)
{
    string text = "krhizmmgmcrecekgyljqkldocicziihtgpqwbticmvuyznragqoyrukzopfmjhjjxemsxmrsxuqmnkrzhgvtgdgtykhcglurvppvcwhrhrjoislonvvglhdciilduvuiebmffaagxerjeewmtcwmhmtwlxtvlbocczlrppmpjbpnifqtlninyzjtmazxdbzwxthpvrfulvrspycqcghuopjirzoeuqhetnbrcdakilzmklxwudxxhwilasbjjhhfgghogqoofsufysmcqeilaivtmfziumjloewbkjvaahsaaggteppqyuoylgpbdwqubaalfwcqrjeycjbbpifjbpigjdnnswocusuprydgrtxuaojeriigwumlovafxnpibjopjfqzrwemoinmptxddgcszmfprdrichjeqcvikynzigleaajcysusqasqadjemgnyvmzmbcfrttrzonwafrnedglhpudovigwvpimttiketopkvqw";
    Solution S;

    cout << S.maxNumberOfBalloons(text);

    return 0;
}