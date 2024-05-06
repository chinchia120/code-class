class Solution
{
public:
    bool hasGroupsSizeX(vector<int>& deck)
    {   
        if(deck.size() == 1) return false;

        sort(deck.begin(), deck.end());  
        
        vector<int> list;
        int tmp = deck[0], cnt = 1;
        for(int i = 1; i < deck.size(); i++)
        {
            if(deck[i] == tmp)
            {
                cnt++;
            }
            else
            {
                list.push_back(cnt);
                cnt = 1;
                tmp = deck[i];
            }
        }
        list.push_back(cnt);
        //show_1d_vector(list);

        if(list.size() == 1) return true;

        sort(list.begin(), list.end());
        
        vector<int> num;
        for(int i = 2; i <= list[0]; i++)
        {
            if(list[0]%i == 0) num.push_back(i);
        }
        //show_1d_vector(num);

        for(int i = 1; i < list.size(); i++)
        {
            for(int j = 0; j < num.size(); j++)
            {
                if(list[i]%num[j] != 0) num.erase(num.begin()+j);
            }
            if(num.size() == 0) return false;
        }

        for(int i = 0; i < list.size(); i++)
        {
            for(int j = 0; j < num.size(); j++)
            {
                if(list[i]%num[j] != 0) return false;
            }
        }
        return true;
    }

    void show_1d_vector(vector<int> vec)
    {
        for(int i = 0; i < vec.size(); i++) cout << vec[i] << endl;
        cout << endl;
    }
};