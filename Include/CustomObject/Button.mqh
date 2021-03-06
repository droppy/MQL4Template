#include <Controls\WndObj.mqh>
#include <ChartObjects\ChartObjectsTxtControls.mqh>


class KButton : public CWndObj
{
   private:
      CChartObjectButton m_button;             // chart object
   
   public:
                        KButton(void);
                       ~KButton(void);
      //--- create
      virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
      //--- state
      bool              Pressed(void)          const { return(m_button.State());                       }
      bool              Pressed(const bool pressed)  { return(m_button.State(pressed));                }
      //--- properties
      bool              Locking(void)          const { return(IS_CAN_LOCK);                            }
      void              Locking(const bool flag);
      
      //--- original
      virtual bool      Corner(const ENUM_BASE_CORNER corner);
   
   protected:
      //--- handlers of object settings
      virtual bool      OnSetText(void)              { return(m_button.Description(m_text));           }
      virtual bool      OnSetColor(void)             { return(m_button.Color(m_color));                }
      virtual bool      OnSetColorBackground(void)   { return(m_button.BackColor(m_color_background)); }
      virtual bool      OnSetColorBorder(void)       { return(m_button.BorderColor(m_color_border));   }
      virtual bool      OnSetFont(void)              { return(m_button.Font(m_font));                  }
      virtual bool      OnSetFontSize(void)          { return(m_button.FontSize(m_font_size));         }
      //--- internal event handlers
      virtual bool      OnCreate(void);
      virtual bool      OnShow(void);
      virtual bool      OnHide(void);
      virtual bool      OnMove(void);
      virtual bool      OnResize(void);
      //--- mouse event
      virtual bool      OnMouseDown(void);
      virtual bool      OnMouseUp(void);
};


KButton::KButton(void)
{
   m_color            = CONTROLS_BUTTON_COLOR;
   m_color_background = CONTROLS_BUTTON_COLOR_BG;
   m_color_border     = CONTROLS_BUTTON_COLOR_BORDER;
}


KButton::~KButton(void)
{
}


bool KButton::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
{
   //--- call method of the parent class
   if (!CWndObj::Create(chart, name, subwin, x1, y1, x2, y2)) {
      return(false);
   }
   
   //--- create the chart object
   if (!m_button.Create(chart, name, subwin, x1, y1, Width(), Height())) {
      return(false);
   }
   
   //--- call the settings handler
   return(OnChange());
}


void KButton::Locking(const bool flag)
{
   if (flag) {
      PropFlagsSet(WND_PROP_FLAG_CAN_LOCK);
   } else {
      PropFlagsReset(WND_PROP_FLAG_CAN_LOCK);
   }
}


bool KButton::OnCreate(void)
{
   //--- create the chart object by previously set parameters
   return(m_button.Create(m_chart_id, m_name, m_subwin, m_rect.left, m_rect.top, m_rect.Width(), m_rect.Height()));
}


bool KButton::OnShow(void)
{
   return(m_button.Timeframes(OBJ_ALL_PERIODS));
}


bool KButton::OnHide(void)
{
   return(m_button.Timeframes(OBJ_NO_PERIODS));
}


bool KButton::OnMove(void)
{
   //--- position the chart object
   return(m_button.X_Distance(m_rect.left) && m_button.Y_Distance(m_rect.top));
}


bool KButton::OnResize(void)
{
   //--- resize the chart object
   return(m_button.X_Size(m_rect.Width()) && m_button.Y_Size(m_rect.Height()));
}


bool KButton::OnMouseDown(void)
{
   if (!IS_CAN_LOCK) {
      Pressed(!Pressed());
   }

   //--- call of the method of the parent class
   return(CWnd::OnMouseDown());
}


bool KButton::OnMouseUp(void)
{
   //--- depress the button if it is not fixed
   if (m_button.State() && !IS_CAN_LOCK) {
      m_button.State(false);
   }

   //--- call of the method of the parent class
   return(CWnd::OnMouseUp());
}


bool KButton::Corner(const ENUM_BASE_CORNER corner)
{
   if (m_chart_id == -1) {
      return(false);
   }
   return(ObjectSetInteger(m_chart_id, m_name, OBJPROP_CORNER, corner));
}
