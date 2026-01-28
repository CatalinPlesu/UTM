/*------------------------------------------------------------
   HELLOWIN.C -- Displays "Hello, Windows 95!" in client area
                 (c) Charles Petzold, 1996
  Adaptat 2020
  ------------------------------------------------------------*/

#include <windows.h> // Windows API

LRESULT CALLBACK WndProc(HWND me, UINT sig, WPARAM wParam, LPARAM lParam);

#define ID_TIMER	1
#define WIN_HANDLED	((LRESULT)0)

/*--------------------------------------------------------------
* The main entry point to the Windows application*/
int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance,
                    PSTR szCmdLine, int iShowCmd)
{
     HWND        hwnd; // "handle" to the window object
     MSG         sig; // message object to receive
     WNDCLASSEX  wnd; // instance of the Window class ('wnd' object)

     UNREFERENCED_PARAMETER(hPrevInstance);
     UNREFERENCED_PARAMETER(szCmdLine);
     // set attributes of the 'wnd' object
     wnd.cbSize        = sizeof (wnd);
     wnd.style         = CS_HREDRAW | CS_VREDRAW;
     wnd.cbClsExtra    = 0;
     wnd.cbWndExtra    = 0;
     wnd.hInstance     = hInstance;
     wnd.hIcon         = NULL; // LoadIcon(NULL, IDI_APPLICATION);
     wnd.hCursor       = LoadCursor(NULL, IDC_ARROW);
     wnd.hbrBackground = GetStockObject (WHITE_BRUSH);
     wnd.lpszMenuName  = NULL;
     wnd.lpszClassName = "HelloWin";
     wnd.hIconSm       = NULL;     
     wnd.lpfnWndProc   = &WndProc; // attach the "window proc" // set virtual 'function' of the 'wnd' object

     RegisterClassEx (&wnd); // register the Window Class with Windows

     // constructor of the 'wnd' class
     hwnd = CreateWindow( 
	wnd.lpszLClassName,	// window class name
	"Hello Windows!", 	// window caption	
	WS_OVERLAPPEDWINDOW,	// window style	
	CW_USEDEFAULT, 		// initial x position
        CW_USEDEFAULT,		// initial y position
        300,			// initial x size
	200,			// initial y size
	NULL,			// parent window handle
	NULL,			// window menu handle
	hInstance,		// program instance handle	
	NULL);			// creation parameters

     ShowWindow (hwnd, iShowCmd);
     UpdateWindow (hwnd);

    // event loop ("message pump")
	while (1) 
	 {
      	  // generically WAIT for any message  to arrive in the que
	  status = GetMessage(&msg, NULL, 0, 0); 
	  if (status == 0) 
		{ // message NOT to be processed?
	  	status = msg.wParam;
	  	break; // terminate the event loop
	  	}	  
          DispatchMessage (&msg); // dispatch to the appropriate "windiw proc" (window service)
          }
     return status; //return to Windows with the status of processing 
}

// The "windows proc" registered for the main window of this application 
LRESULT CALLBACK WndProc(HWND me, UINT sig, WPARAM wParam, LPARAM lParam)
{
	//static int wm_timer_ctr = 0	// counter incremented in WM_TIMER 
	static int wm_mousemove_ctr = 0	// counter incremented in WM_MOUSEMOVE  
	static int wm_keydown_ctr = 0	// counter incremented in WM_KEYDOWN  

	LRESULT status; // status of the processing to report back to Windows

     switch (sig)  // signal of the message
	  {
          case WM_CREATE: { // window was created
		SetTimer(me, ID_TIMER, 100, NULL); 100ms interval
		status = WIN_HANDLED; // report event handled
             break;
	   }

          case WM_PAINT: // window need to bee repainted
	  {
	   HDC         hdc;
	   PAINTSTRUCT ps;
	   RECT        rect;
	   char cBuffer[100];
	   wsprintf(cBuffer, "KEYBOARD=%3d, MOUSE=%3d", 
		(wm_keydown_ctr %1000), 
		(wm_mousemove_ctr %1000));

	   // painting preformed between BeginPaint() and EndPaint()
	   hdc = BeginPaint(me, &ps);	
	   GetClientRect(me, &rect);	 
	   DrawText(hdc, cBuffer, -1, &rect,
		    DT_SINGLELINE | DT_CENTER | DT_VCENTER);
           EndPaint (hwnd, &ps);
	   status = WIN_HANDLED; // report event handled
	   break;
	   }
	case WM_KEYDOWN:  // keyboard key has been pressed
	  {
	   ++wm_keydown_ctr;
	   InvalidateRect(me, NULL, FALSE); // force repainting
	   status = WIN_HANDLED; // report event handled	  
	   break;
	   }
	case WM_MOUSEMOVE:  // mouse has been moved over the window
	  {
	   ++wm_mousemove_ctr;
	   InvalidateRect(me, NULL, FALSE); // force repainting
	   status = WIN_HANDLED; // report event handled	  
	   break;
	   }
	case WM_DESTROY: // window is about to be destroyed
	  {	
		 PostQuitMessage (0);
		 status = WIN_HANDLED; // report event handled	
		 break;
           }
	   default: // default behavior (characteristic "look and..." 
		    // report the status of default processing
	   {	
	    status = DefWindowProc(me, sig, wParam, lParam);
	    break;
	    }
	}
	return status; // return to Windows with the status of process
}
