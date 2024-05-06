class Solution
{
public:
    int numWaterBottles(int numBottles, int numExchange)
    {
        int empty = numBottles , drink = numBottles;
        while(empty/numExchange != 0)
        {   
            int tmp = empty;
            drink += tmp/numExchange;
            empty %= numExchange;
            empty += tmp/numExchange;
        }
        return drink;
    }
};