class Solution
{
public:
    vector<bool> kidsWithCandies(vector<int>& candies, int extraCandies)
    {   
        int maxCandy = 0;
        for(int candy: candies) maxCandy = max(maxCandy, candy);

        vector<bool> GreasetAmongKids (candies.size(), false);
        for(int i = 0; i < candies.size(); i++)
        {
            if(candies[i]+extraCandies >= maxCandy) GreasetAmongKids[i] = true;
        }
        return GreasetAmongKids;
    }
};