class Solution {
public:
    string reformatDate(string date)
    {
        vector<string> str_spt = split_string(date);
        str_spt[0].pop_back();
        str_spt[0].pop_back();

        string month = "";
        vector<string> month_list = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        for(int i = 0; i < month_list.size(); i++)
        {
            string str = month_list[i];
            if(str == str_spt[1])
            {
                if(i+1 < 10)
                {
                    month.push_back('0');
                    month.push_back((i+1)+'0');
                }
                else month = to_string(i+1);
                break;
            }
        }
        if(stoi(str_spt[0]) < 10) str_spt[0].insert(str_spt[0].begin(), '0');
        return str_spt[2] +  "-" + month + "-" + str_spt[0];
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