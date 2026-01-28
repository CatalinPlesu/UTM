#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

static TCHAR szWindowClass[] = _T("DesktopApp");
static TCHAR szTitle[] = _T("Programarea Pilotata de Evenimente");
POINT apt[4]; // definim variabila globala
RECT r;
HINSTANCE hInst;
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
void InitBezierParams(); // Initializam punctele pentru Bezier
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
    InitBezierParams(); // Chemam functia care initializeaza pentru prima data punctele curbei Bezier
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
// functia care initializeaza punctele
void InitBezierParams()
{
    
    apt[0].x = 220; apt[0].y = 110;
    apt[1].x = 260; apt[1].y = 20;
    apt[2].x = 360; apt[2].y = 190;
    apt[3].x = 420; apt[3].y = 110;
    
   }
 LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT ps;
    HDC hdc;
    TCHAR greeting[] = _T("Curba Besier prin functii GDI");
    
    
   
    switch (message)
    {
    
    case WM_KEYDOWN:
        
        //deplasarea punctului de control 
        if (GetAsyncKeyState(VK_CONTROL)  )
        {
            switch (wParam)
            {
            case VK_LEFT:
                apt[2].x -= 10;
                break;
            case VK_RIGHT:
               apt[2].x += 6;
                break;
            case VK_UP:
                apt[2].y -= 10;
                break;
            case VK_DOWN:
                apt[2].y += 6;
                break;
            }
        }
        else
        {
           if (GetAsyncKeyState(VK_SPACE))
           {
                switch (wParam)
                {
                case VK_LEFT:
                {
                    for (size_t i = 0; i < 4; i++)
                    {
                        apt[i].x--;
                    }
                }
                break;
                case VK_RIGHT:
                {
                    for (size_t i = 0; i < 4; i++)
                    {
                        apt[i].x++;
                    }
                }
                break;
                case VK_UP: 
                {
                    for (size_t i = 0; i < 4; i++)
                    {
                        apt[i].y--;
                    }
                }
                break;
                case VK_DOWN:
                {
                    for (size_t i = 0; i < 4; i++)
                    {
                        apt[i].y++;
                    }
                }
                break;
                }
           }
           else
           {
               if (GetAsyncKeyState(VK_SHIFT)) {
                   switch (wParam)
                   {
                   case VK_LEFT:
                       GetClientRect(hWnd, &r);
                       apt[0].x = r.right / 4;          apt[0].y = r.bottom / 2;
                       apt[1].x = r.right / 2;          apt[1].y = r.bottom / 4;
                       apt[2].x = r.right / 2;      apt[2].y = 3 * r.bottom / 4;
                       apt[3].x = 3 * r.right / 4;      apt[3].y = r.bottom / 2;
                       break;
                   case VK_RIGHT:
                       GetClientRect(hWnd, &r);
                       apt[0].x = r.right / 2;          apt[0].y = r.bottom / 4;
                       apt[1].x = 3 * r.right / 4;      apt[1].y = r.bottom / 2;
                       apt[2].x = r.right / 4;          apt[2].y = r.bottom / 2;
                       apt[3].x = r.right / 2;      apt[3].y = 3 * r.bottom / 4;
                       break;
                   
                   }
               }
               else {
                   switch (wParam)
                   {
                   case VK_LEFT:
                       apt[1].x -= 10;
                       break;
                   case VK_RIGHT:
                       apt[1].x += 6;
                       break;
                   case VK_UP:
                       apt[1].y -= 10;
                       break;
                   case VK_DOWN:
                       apt[1].y += 6;
                       break;
                   }
               }
           }
        }
        InvalidateRect(hWnd, NULL, TRUE);
        break;
    case WM_PAINT:
        hdc = BeginPaint(hWnd, &ps);
        SetTextColor(hdc, RGB(50, 70, 70));
        SetBkMode(hdc, TRANSPARENT);
        TextOut(hdc, 10, 10, greeting, _tcslen(greeting));
        // Desenarea curbei prin funtie GDI  
   //InvalidateRect(hWnd, NULL, TRUE);
        PolyBezier(hdc, apt, 4); 
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
