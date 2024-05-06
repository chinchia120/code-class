class Solution
{
public:
    string reverseOnlyLetters(string s)
    {   
        string str_copy = s, str_rm = "";
        reverse(s.begin(), s.end());
        for(int i = 0; i < s.length(); i++)
        {
            if(((int)s[i] >= 65 && (int)s[i] <= 90) || ((int)s[i] >= 97 && (int)s[i] <= 122))
            {
                str_rm.push_back(s[i]);
            }
        }
        cout << str_rm << endl;
        cout << str_copy << endl;

        int index = 0;
        for(int i = 0; i < str_copy.length(); i++)
        {
            if(((int)str_copy[i] >= 65 && (int)str_copy[i] <= 90) || ((int)str_copy[i] >= 97 && (int)str_copy[i] <= 122))
            {   
                cout << str_copy[i] << endl;
                str_copy[i] = str_rm[index];
                index++;
            }
        }
        return str_copy;
    }
};