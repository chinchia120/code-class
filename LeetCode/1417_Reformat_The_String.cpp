class Solution
{
public:
    string reformat(string s)
    {   
        int cnt1 = 0, cnt2 = 0;
        for(char ch: s)
        {
            if((int)ch >= 48 && (int)ch <= 57) cnt1++;
            else cnt2++;
        }
        if(abs(cnt1-cnt2) > 1) return "";

        vector<int> vec_ch, vec_num;
        for(int i = 0; i < s.length(); i++)
        {   
            if((int)s[i] >= 48 && (int)s[i] <= 57) vec_num.push_back((int)s[i]);
            else vec_ch.push_back((int)s[i]);
        }

        string str = "";
        if(vec_ch.size() > vec_num.size())
        {
            for(int i = 0; i < vec_num.size(); i++)
            {
                str.push_back(vec_ch[i]);
                str.push_back(vec_num[i]);
            }
            str.push_back(vec_ch.back());
        }

        if(vec_ch.size() < vec_num.size())
        {
            for(int i = 0; i < vec_ch.size(); i++)
            {
                str.push_back(vec_num[i]);
                str.push_back(vec_ch[i]);    
            }
            str.push_back(vec_num.back());
        }

        if(vec_ch.size() == vec_num.size())
        {
            for(int i = 0; i < vec_ch.size(); i++)
            {
                str.push_back(vec_num[i]);
                str.push_back(vec_ch[i]);    
            }
        }
        return str;
    }
};