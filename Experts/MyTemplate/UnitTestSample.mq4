//+------------------------------------------------------------------+
//|                                               UnitTestSample.mq4 |
//|                                 Copyright 2018, Keisuke Iwabuchi |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Keisuke Iwabuchi"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include <MyTemplate\UnitTest.mqh>


UnitTest *test;


int OnInit()
{
    test = new UnitTest("Sample");

    return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason)
{
    delete test;
}


void OnTick()
{
    test.assertTrue(isOdd(1));
    test.assertFileEquals("test1.txt", "test2.txt");
    
    ExpertRemove();
}


bool isOdd(int value)
{
    return(value % 2 == 1);
}
