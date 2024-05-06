class Solution
{
public:
    int findLucky(vector<int>& arr)
    {
        vector<vector<int>> num_cnt;
        int index = 0;
        for(int num: arr)
        {   
            int flag = 0;
            for(int j = 0; j < num_cnt.size(); j++)
            {   
                if(num == num_cnt[j][0])
                {   
                    num_cnt[j][1]++;
                    flag = 1;
                    break;
                }
            }
            if(flag == 0)
            {
                num_cnt.push_back(vector<int> ());
                num_cnt[index].push_back(num);
                num_cnt[index].push_back(1);
                index++;
            }
        }
        sort(num_cnt.begin(), num_cnt.end());

        for(int i = num_cnt.size()-1; i >= 0; i--)
        {
            if(num_cnt[i][0] == num_cnt[i][1]) return num_cnt[i][0];
        }
        return -1;
    }

    void show_2d_vector(vector<vector<int>> vec)
    {
        for(vector<int> vec1: vec)
        {
            for(int num: vec1) cout << num << " ";
            cout << endl;
        }
    }
};