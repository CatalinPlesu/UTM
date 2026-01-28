#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>
#include <windows.h>
#include <gdiplus.h>
using namespace Gdiplus;

#define BEZIER_GDI 1000
#define BEZIER_MATH 1001
#define BEZIER_CUBIC 1002
#define BEZIER_NONE 1003
HMENU hMainMenu;
HMENU hFuncMenu;

int bezier_mode = 0;
int translation_mode = 4;

float radius = 7;
float last_x = 0;
float last_y = 0;

static TCHAR szWindowClass[] = _T("DesktopApp");
static TCHAR szTitle[] = _T("Plesu Catalin lab 3 PPE");

POINT apt[4];
HINSTANCE hInst;

#define PI 3.14159265
POINT rotate_point(POINT c, POINT p, FLOAT angle)
{
  angle =  angle * PI / 180;
  float _sin = sin(angle);
  float _cos = cos(angle);
  p.x -= c.x;
  p.y -= c.y;
  float xnew = p.x * _cos - p.y * _sin;
  float ynew = p.x * _sin + p.y * _cos;
  p.x = xnew + c.x;
  p.y = ynew + c.y;
  return p;
}

POINT center_apt() {
    POINT center;
    center.x = (apt[0].x + apt[3].x) / 2.;
    center.y = (apt[0].y + apt[3].y) / 2.;
    return center;
}

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
void InitBezierParams();

int CALLBACK WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPSTR lpCmdLine, _In_ int nCmdShow)
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

    if (!RegisterClassEx(&wcex)) {
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
        WS_OVERLAPPEDWINDOW, 500, 500, 500, 500,
        NULL,
        NULL,
        hInstance,
        NULL);
    if (!hWnd) {
        MessageBox(NULL,
            _T("Call to CreateWindow failed!"),
            _T("Windows Desktop Guided Tour"),
            NULL);
        return 1;
    }

    GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR           gdiplusToken;
    GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);


    InitBezierParams();
    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    GdiplusShutdown(gdiplusToken);
    return (int)msg.wParam;
}

void InitBezierParams()
{

    apt[0].x = 220;
    apt[0].y = 110;
    apt[1].x = 260;
    apt[1].y = 20;
    apt[2].x = 360;
    apt[2].y = 190;
    apt[3].x = 420;
    apt[3].y = 110;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT ps;
    HDC hdc;
    TCHAR* greetings[] = {
        _T("Nu este afisat nimic"),
        _T("Curba Besier prin functii GDI"),
        _T("Curba Besier, prin formule matematice"),
        _T("Curba Besier cubica, prin formule matematice")
    };

    switch (message) {
    case WM_CREATE: {
    TCHAR* greetings[] = {
        _T("Nu este afisat nimic"),
        _T("Curba Besier prin functii GDI"),
        _T("Curba Besier, prin formule matematice"),
        _T("Curba Besier cubica, prin formule matematice")
    };
        hMainMenu = CreateMenu();
        hFuncMenu = CreateMenu();
        AppendMenu(hFuncMenu, MF_BYPOSITION | MF_STRING, BEZIER_GDI, "GDI");
        AppendMenu(hFuncMenu, MF_BYPOSITION | MF_STRING, BEZIER_MATH, "Math");
        AppendMenu(hFuncMenu, MF_BYPOSITION | MF_STRING, BEZIER_CUBIC, "Cubic");
        AppendMenu(hFuncMenu, MF_BYPOSITION | MF_STRING, BEZIER_NONE, "None");
        AppendMenu(hMainMenu, MF_POPUP | MF_STRING, (UINT)hFuncMenu, "Bezier");
        SetMenu(hWnd, hMainMenu);
        break;
    }

    case WM_COMMAND: {
        if (wParam == BEZIER_GDI) {
            bezier_mode = 1;
        }
        if (wParam == BEZIER_MATH) {
            bezier_mode = 2;
        }
        if (wParam == BEZIER_CUBIC) {
            bezier_mode = 3;
        }
        if (wParam == BEZIER_NONE) {
            bezier_mode = 0;
        }
        InvalidateRect(hWnd, NULL, TRUE);
        break;
    }

    case WM_KEYDOWN: {


        if (GetAsyncKeyState(VK_SHIFT)  )
        {
            switch (wParam)
            {
            case VK_LEFT:
                {
                /* POINT center = center_apt(); */
                for (int i = 0; i < 4; i++)
                   if (i != 2)
                    apt[i] = rotate_point(apt[2], apt[i], +5);
                /* apt[2].x -= 10; */
                break;
                }
            case VK_RIGHT:
                {
                /* POINT center = center_apt(); */
                for (int i = 0; i < 4; i++)
                   if (i != 2)
                    apt[i] = rotate_point(apt[2], apt[i], -5);
               /* apt[2].x += 6; */
                break;
                }
            }
        } else
        switch (wParam) {
        case VK_SPACE:
            translation_mode += 1;
            if (translation_mode > 4)
                translation_mode = 0;
            break;
        case VK_LEFT:
            if (translation_mode == 4)
                for (int i = 0; i < translation_mode; i++)
                    apt[i].x -= 10;
            else
            apt[translation_mode].x -= 10;
            break;
        case VK_RIGHT:
            if (translation_mode == 4)
                for (int i = 0; i < translation_mode; i++)
                    apt[i].x += 6;
            else
            apt[translation_mode].x += 6;
            break;
        case VK_UP:
            if (translation_mode == 4)
                for (int i = 0; i < translation_mode; i++)
                    apt[i].y -= 10;
            else
            apt[translation_mode].y -= 10;
            break;
        case VK_DOWN:
            if (translation_mode == 4)
                for (int i = 0; i < translation_mode; i++)
                    apt[i].y += 6;
            else
            apt[translation_mode].y += 6;
            break;
        }

        InvalidateRect(hWnd, NULL, TRUE);
        break;
    }

     case WM_LBUTTONDOWN:
         {
           hdc = GetDC (hWnd) ;
           last_x = LOWORD (lParam);
           last_y = HIWORD (lParam); 
           ReleaseDC (hWnd, hdc) ;
          InvalidateRect (hWnd, NULL, TRUE) ;
          break;
         }

     case WM_RBUTTONDOWN:
         {
           hdc = GetDC (hWnd) ;
           last_x = LOWORD (lParam);
           last_y = HIWORD (lParam); 
           ReleaseDC (hWnd, hdc) ;
          InvalidateRect (hWnd, NULL, TRUE) ;
          break;
         }

     case WM_MOUSEMOVE:
         {
           hdc = GetDC (hWnd) ;
           float dx = LOWORD (lParam) - last_x;
           float dy = HIWORD (lParam) - last_y;
          if (wParam & MK_LBUTTON )
          {
               /* SetPixel (hdc, LOWORD (lParam), HIWORD (lParam), 0) ; */
               bool one_point = false;

               for (int i = 0; i < 4; i++) {
                   if (sqrt(pow(apt[i].x - last_x, 2) + pow(apt[i].y - last_y, 2)) < radius * 2) {
                       apt[i].x += dx;
                       apt[i].y += dy;
                       one_point = true;
                       translation_mode = i;
                       break;
                   }
               }
               if (!one_point) {
               for (int i = 0; i < 4; i++) {
                       apt[i].x += dx;
                       apt[i].y += dy;
                   }
               translation_mode = 4;
               }
          }
          else if (wParam & MK_RBUTTON )
          {

               /* POINT center = center_apt(); */

               for (int i = 0; i < 4; i++) {
                   if (i != 2)
                       apt[i] = rotate_point(apt[2], apt[i], dy);
                   }

          }
          last_x = LOWORD (lParam);
          last_y = HIWORD (lParam); 
          ReleaseDC (hWnd, hdc) ;
          InvalidateRect (hWnd, NULL, TRUE) ;
          break;
         }

    case WM_PAINT: {
        hdc = BeginPaint(hWnd, &ps);
        Graphics graphics(hdc);
        SolidBrush yellowBrush(Color(255, 215, 153, 33));
        SolidBrush redBrush(Color(255, 204, 36, 29));
        SolidBrush greenBrush(Color(255, 152, 151, 26));
        Pen bluePen(Color(255, 69, 133, 136), 1);
        Pen greenPen(Color(255, 152, 151,  26) , 3);
        Pen purplePen(Color(255, 177,  98, 134), 3);


        HBRUSH brush = CreateSolidBrush(RGB(251, 241, 199));
        SelectObject(hdc, brush); 
        Rectangle(hdc, 0, 0, 2000, 2000); 

        SetTextColor(hdc, RGB(50, 70, 70));
        SetBkMode(hdc, TRANSPARENT);
        TextOut(hdc, 10, 10, greetings[bezier_mode], _tcslen(greetings[bezier_mode]));
        // Desenarea curbei prin funtie GDI
        // InvalidateRect(hWnd, NULL, TRUE);

        SelectObject(hdc, CreatePen(PS_SOLID, 3, RGB(69, 133, 136)));       
        switch (bezier_mode) {
        case 1:
        {
            graphics.DrawLine(&bluePen, int(apt[0].x), int(apt[0].y), int(apt[1].x), int(apt[1].y));
            graphics.DrawLine(&bluePen, int(apt[2].x), int(apt[2].y), int(apt[3].x), int(apt[3].y));
            PolyBezier(hdc, apt, 4);
            break;
        }
        case 2:
        {
            graphics.DrawLine(&bluePen, int(apt[0].x), int(apt[0].y), int(apt[1].x), int(apt[1].y));
            graphics.DrawLine(&bluePen, int(apt[2].x), int(apt[2].y), int(apt[3].x), int(apt[3].y));
            double xu = apt[0].x, yu = apt[0].y;
            for (double u = 0.0; u <= 1.04; u += 0.05)
            {
                double nxu = pow(1 - u, 3) * apt[0].x + 3 * u * pow(1 - u, 2) * apt[1].x + 3 * pow(u, 2) * (1 - u) * apt[2].x + pow(u, 3) * apt[3].x;
                double nyu = pow(1 - u, 3) * apt[0].y + 3 * u * pow(1 - u, 2) * apt[1].y + 3 * pow(u, 2) * (1 - u) * apt[2].y + pow(u, 3) * apt[3].y;
                /* SetPixel(hdc, (int)xu, (int)yu, RGB(152, 151, 26)); */

                graphics.DrawLine(&greenPen, int(xu), int(yu), int(nxu), int(nyu));
                xu = nxu;
                yu = nyu;
            }
            break;
        }
        case 3:
        {
            graphics.DrawLine(&bluePen, int(apt[0].x), int(apt[0].y), int(apt[1].x), int(apt[1].y));
            graphics.DrawLine(&bluePen, int(apt[1].x), int(apt[1].y), int(apt[3].x), int(apt[3].y));
            double xu = apt[0].x, yu = apt[0].y;
            for (double u = 0.0; u <= 1.04; u += 0.05)
            {
                double nxu = pow(1 - u, 2) * apt[0].x + 2 * (1 - u ) * u * apt[1].x + pow(u, 2) * apt[3].x;
                double nyu = pow(1 - u, 2) * apt[0].y + 2 * (1 - u ) * u * apt[1].y + pow(u, 2) * apt[3].y;
                /* SetPixel(hdc, (int)xu, (int)yu, RGB(177, 98, 134)); */
                graphics.DrawLine(&purplePen, int(xu), int(yu), int(nxu), int(nyu));
                xu = nxu;
                yu = nyu;
            }
            break;
        }
        default:
            break;
        }

        for (int i = 0; i < 4; i++) {
            if (i == translation_mode)
                graphics.FillEllipse(&redBrush, apt[i].x-radius, apt[i].y-radius, 2*radius, 2*radius);
            else
                graphics.FillEllipse(&yellowBrush, apt[i].x-radius, apt[i].y-radius, 2*radius, 2*radius);
        }

        EndPaint(hWnd, &ps);
        break;
    }
    case WM_DESTROY: {
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
        break;
    }
    }
    return 0;
}
