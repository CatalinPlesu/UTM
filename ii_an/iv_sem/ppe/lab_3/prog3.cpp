#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <math.h>
#define IDT_TIMER1      151L // se defineste un identificator pentru  TIMER
static TCHAR szWindowClass[] = _T("DesktopApp");
static TCHAR szTitle[] = _T("Programarea Pilotata de Evenimente");
HINSTANCE hInst;
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
int CALLBACK WinMain( _In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance,  _In_ LPSTR  lpCmdLine,  _In_ int  nCmdShow)
{
    WNDCLASSEX wcex;
    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc = WndProc;
    wcex.cbClsExtra = 0;
    wcex.cbWndExtra = 0;
    wcex.hInstance = hInstance;
    wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
    wcex.hIcon = LoadIcon(NULL, IDI_APPLICATION);
    wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wcex.lpszMenuName = NULL;
    wcex.lpszClassName = szWindowClass;
    wcex.hIconSm = LoadIcon(NULL, IDI_APPLICATION);

    if (!RegisterClassEx(&wcex))
    {
        MessageBox(NULL,
            _T("Call to RegisterClassEx failed!"),
            _T("Windows Desktop Guided Tour"),
            NULL);
        return 1;
    }
    hInst = hInstance;
      HWND hWnd = CreateWindow(
        szWindowClass,
        szTitle,
        WS_OVERLAPPEDWINDOW,500, 500, 500,  500, 
        //CW_USEDEFAULT, CW_USEDEFAULT,
        //CW_USEDEFAULT, CW_USEDEFAULT,
        NULL,
        NULL,
        hInstance,
        NULL
    );
    if (!hWnd)
    {
        MessageBox(NULL,
            _T("Call to CreateWindow failed!"),
            _T("Windows Desktop Guided Tour"),
            NULL);
        return 1;
    }
    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);
    
     MSG msg;
    while (GetMessage(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    
    
    return (int)msg.wParam;
}
 LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT ps;
    HDC hdc;
    TCHAR greeting[] = _T("Curba Besier, prin formule matematice");
   
   
    switch (message)
    {
   
    case WM_PAINT:
        hdc = BeginPaint(hWnd, &ps);
               
         SetTextColor(hdc, RGB(50, 70, 70));
         SetBkMode(hdc, TRANSPARENT);
         TextOut(hdc, 10, 10, greeting, _tcslen(greeting));
                
        {//desenare curba bezier dupa formula
            int x[4] = { 20, 60, 160, 220 };
            int y[4] = { 110, 20, 190, 110 };
            double xu, yu;
            for (double u = 0.0; u <= 1.0; u += 0.0001)
            {
                xu = (pow(1 - u, 3) * x[0] + 3 * u * pow(1 - u, 2) * x[1] + 3 * pow(u, 2) * (1 - u) * x[2] + pow(u, 3) * x[3]);
                yu = pow(1 - u, 3) * y[0] + 3 * u * pow(1 - u, 2) * y[1] + 3 * pow(u, 2) * (1 - u) * y[2] + pow(u, 3) * y[3];
                SetPixel(hdc, (int)xu, (int)yu, RGB(125, 120, 235));
            }
        }
        EndPaint(hWnd, &ps);
        
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
      
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
        break;
    }
    return 0;
}
