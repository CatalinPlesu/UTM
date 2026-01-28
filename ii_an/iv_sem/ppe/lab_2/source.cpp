#include <windows.h>
/* #include <objidl.h> */
#include <gdiplus.h>

#include <iostream>
#include <math.h>       
using namespace Gdiplus;

#define PI 3.14159265
int ELAPSED = 100;

typedef struct{
    float x;
    float y;
} point;

typedef struct{
    point a;
    point b;
    point c;
} line;

typedef struct{
    point c;
    point r;
} circle;

line l = {0,0,0,0,0,0};
line l2 = {0,0,0,0,0,0};
circle c1 = { 150,300,50,55};

point rotate_point(point c, point p, float angle)
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

line rotate_line(line l, float angle) {

    l.a = rotate_point(l.c, l.a, angle);
    l.b = rotate_point(l.c, l.b, angle);
    return l;
}

VOID AnimationLoop(HWND hwnd)
{
    PAINTSTRUCT  ps;
    HDC hdc = BeginPaint(hwnd, &ps);
    Graphics graphics(hdc);
    Pen redPen(Color(255, 204,  36,  29), 6);
    Pen greenPen(Color(255, 152, 151,  26) , 6);
    Pen bluePen(Color(255, 69, 133, 136), 6);
    Pen yellowPen(Color(255, 215, 153,  33), 6);
    Pen orangePen(Color(255, 214,  93,  14), 6);
    Pen purplePen(Color(255, 177,  98, 134), 6);

    HBRUSH brush = CreateSolidBrush(RGB(251, 241, 199));
    SolidBrush blueBrush(Color(255, 69, 133, 136));

    FontFamily  fontFamily(L"Times New Roman");
    Font        font(&fontFamily, 24, FontStyleRegular, UnitPixel);
    PointF      pointF(5.0f, 5.0f);

    l = rotate_line(l, 1);
    l2 = rotate_line(l2, -2);

    c1.c = rotate_point(l.c, c1.c, 2);

    SelectObject(hdc, brush); 

    RECT rect;
    if(GetWindowRect(hwnd, &rect))
    {
      int width = rect.right - rect.left;
      int height = rect.bottom - rect.top;
      Rectangle(hdc, 0, 0, width, height); 
      graphics.DrawString(L"Smoe solar sistem (;-_-)/", -1, &font, pointF, &blueBrush);

      /* graphics.DrawLine(&yellowPen, 0, 0, width, height); */
      /* graphics.DrawLine(&yellowPen, 0, height, width, 0); */

      /* graphics.DrawEllipse(&bluePen, c1.c.x, c1.c.y, c1.r.x, c1.r.y); */
      graphics.FillEllipse(&blueBrush, c1.c.x, c1.c.y, c1.r.x, c1.r.y);

      int n = 16;
      for (int i = 0; i < n; i++) {
        line ln = rotate_line(l, i * (360.0/n));
        line lp = rotate_line(l2, i * (360.0/n));
        graphics.DrawLine(&redPen, ln.a.x, ln.a.y, ln.b.x, ln.b.y);
        graphics.DrawLine(&yellowPen, lp.a.x, lp.a.y, lp.b.x, lp.b.y);
      }

    Bitmap *bmp = Bitmap::FromFile( L"astronaut.png");
    int scale = 4;
    Rect astronaut(900, 50, bmp->GetWidth() / scale, bmp->GetHeight() / scale);
    graphics.DrawImage(bmp, astronaut);
    }
    EndPaint(hwnd, &ps);
}

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

INT WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, PSTR, INT iCmdShow)
{
    HWND                hWnd;
    MSG                 msg;
    WNDCLASS            wndClass;
    GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR           gdiplusToken;

    // Initialize GDI+.
    GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

    wndClass.style = CS_HREDRAW | CS_VREDRAW;
    wndClass.lpfnWndProc = WndProc;
    wndClass.cbClsExtra = 0;
    wndClass.cbWndExtra = 0;
    wndClass.hInstance = hInstance;
    wndClass.hIcon = LoadIcon(NULL, IDI_APPLICATION);
    wndClass.hCursor = LoadCursor(NULL, IDC_ARROW);
    wndClass.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
    wndClass.lpszMenuName = NULL;
    wndClass.lpszClassName = TEXT("GC_LAB2");

    RegisterClass(&wndClass);

    hWnd = CreateWindow(
        TEXT("GC_LAB2"),                 // window class name
        TEXT("PLESU CATALIN GC LAB 2"),  // window caption
        WS_OVERLAPPEDWINDOW,             // window style
        CW_USEDEFAULT,                   // initial x position
        CW_USEDEFAULT,                   // initial y position
        CW_USEDEFAULT,                   // initial x size
        CW_USEDEFAULT,                   // initial y size
        NULL,                            // parent window handle
        NULL,                            // window menu handle
        hInstance,                       // program instance handle
        NULL);                           // creation parameters

    ShowWindow(hWnd, iCmdShow);
    UpdateWindow(hWnd);

    const int ID_TIMER = 1;
      int ret = SetTimer(hWnd, ID_TIMER, ELAPSED, NULL);
    if(ret == 0)
        MessageBox(hWnd, "Could not SetTimer()!", "Error", MB_OK | MB_ICONEXCLAMATION);


    RECT rect;
    if(GetWindowRect(hWnd, &rect))
    {
      int cwidth = (rect.right - rect.left)/2;
      int cheight = (rect.bottom - rect.top)/2;
      std::cout << cwidth << cheight << std::endl;
      l.c.x = cwidth;
      l.c.y = cheight;
      l2.c.x = cwidth;
      l2.c.y = cheight;
      float l1len = 50;
      float l2len = 25;
      float x1_gap = 20;
      float x2_gap = 5;
      float y_offset = -10;

      l.a.x = cwidth - x1_gap;
      l.a.y = cheight;
      l.b.x = cwidth - (x1_gap + l1len);
      l.b.y = cheight + y_offset;

      l2.a.x = cwidth - (x1_gap + x2_gap + l1len);
      l2.a.y = cheight + y_offset;
      l2.b.x = cwidth - (x1_gap + x2_gap + l1len + l2len);
      l2.b.y = cheight;

    }


    while (GetMessage(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    KillTimer(hWnd, ID_TIMER);
    GdiplusShutdown(gdiplusToken);
    return msg.wParam;
}  // WinMain

LRESULT CALLBACK WndProc(HWND hWnd, UINT message,
    WPARAM wParam, LPARAM lParam)
{

    switch (message)
    {
    case WM_TIMER:
        RedrawWindow(hWnd,NULL,NULL,RDW_INVALIDATE | RDW_ERASE);
        return 0;
    case WM_PAINT:
        AnimationLoop(hWnd);
        return 0;
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
} // WndProc
