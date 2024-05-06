class Solution
{
public:
    int isPrefixOfWord(string sentence, string searchWord)
    {   
        vector<string> str_spt = split_string(sentence);
        for(int i = 0; i < str_spt.size(); i++)
        {   
            string tmp = "", str = str_spt[i];
            if(str[0] == searchWord[0])
            {   
                int flag = 1;
                for(int k = 0; k < searchWord.length(); k++)
                {   
                    if(k == str.length())
                    {
                        flag = 0;
                        break;
                    }
                    if(str[k] != searchWord[k])
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1) return i+1;
            }
        }
        return -1;
    }

    vector<string> split_string(string str)
    {
        vector<string> vec;
        string tmp = "";
        for(char ch: str)
        {
            if(!tmp.empty() && ch == ' ')
            {
                vec.push_back(tmp);
                tmp = "";
            }
            else tmp.push_back(ch);
        }
        if(!tmp.empty()) vec.push_back(tmp);
        return vec;
    }
};