#property strict
#property version   "1.02"


#define TRADE_RETRY 0


#include <Template_1.02.mqh>


extern double Lots              = 0.1;   // 取引数量
extern int    MagicNumber       = 123;   // マジックナンバー
extern double TP                = 100;   // 利食い(pips)
extern double SL                = 100;   // 損切り(pips)
extern double Slippage          = 1.0;   // スリッページ(pips)
/* extern */ bool   IsMoneyManagement = false; // 複利機能
/* extern */ double Risk              = 1.0;   // 複利機能の取引リスク(%)


int  TradeBar = 0;
int  Mult = 10;
bool IsTrade = true;


int OnInit()
{
   TradeBar = Bars;
   Mult = (Digits == 3 || Digits == 5) ? 10 : 1;

   return(INIT_SUCCEEDED);
}


void OnTick()
{
   double lots = Lots;
   double pos = getOrderLots(OPEN_POS, MagicNumber);

   if (pos == 0 && !IsTrade) {
      int entry_signal = getEntrySignal();
      int trade_type = -1;
      double trade_price = 0;
      
      if (entry_signal == 1) {
         trade_type = OP_BUY;
         trade_price = Ask;
      } else if (entry_signal == -1) {
         trade_type = OP_SELL;
         trade_price = Bid;
      }
      
      if (trade_type >= 0 && TradeBar != Bars) {
         if (IsMoneyManagement) {
            lots = MoneyManagement(Risk, SL);
         }
         if (lots == 0) {
            lots = Lots;
         }
         int trade_result = EntryWithPips(trade_type, lots, trade_price, Slippage, SL, TP, COMMENT, MagicNumber);
         if (trade_result == 0) {
            TradeBar = Bars;
         } else {
            if (TRADE_RETRY > 0) {
               TradeBar = Bars;
            }
            if (trade_result == 134 && IsTesting()) {
               IsTrade = false;
            }
         }
      }
   } else {
      bool exit_signal = getExitSignal();
      
      if (exit_signal == 1) {
         Exit(Slippage, MagicNumber);
      }
   }
}


void OnDeinit(const int reason)
{
   Comment("");
}


int getEntrySignal()
{
   return(0);
}


int getExitSignal()
{
   return(0);
}
