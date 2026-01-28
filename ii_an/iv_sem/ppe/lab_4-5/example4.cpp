#include <tchar.h>
#include <windows.h>

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    WNDCLASSEX wc = { 0 };
    MSG msg;
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInstance;
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wc.lpszClassName = TEXT("myWindowClass");
    RegisterClassEx(&wc);
    // create window with scrollbar
    CreateWindowEx(WS_EX_CLIENTEDGE, TEXT("myWindowClass"), TEXT("Scrollbar demo"), WS_THICKFRAME | WS_OVERLAPPEDWINDOW | WS_VISIBLE | WS_OVERLAPPEDWINDOW | WS_VSCROLL, CW_USEDEFAULT, CW_USEDEFAULT, 240, 120, NULL, NULL, hInstance, NULL);
    while (GetMessage(&msg, NULL, 0, 0) > 0) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return msg.wParam;
}
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT Ps;
    SCROLLINFO si;
    HDC hdc;
    static int yClient;
    int totalwords = 100;
    static int yPos;
    static int rows;
    switch (msg) {
    case WM_PAINT: // traps paint message
    {
        hdc = BeginPaint(hwnd, &Ps);
        TCHAR sbv[10] = TEXT("\0");
        int count;
        int linecount = 0;
        int startline = GetScrollPos(hwnd, SB_VERT);
        int endline = startline + rows;
        // output line number
        for (count = startline; count < endline; count++) {
            wsprintf(sbv, TEXT("%d"), count + 1);
            TextOut(hdc, 0, linecount, sbv, strlen(sbv));
            if (count == 0)
                TextOut(hdc, 0, linecount+15, _T("test question"), 13);
            linecount = linecount + 30;
        }
        EndPaint(hwnd, &Ps);
        DeleteDC(hdc);
    } break;
    // deals with changes in widows sizr
    case WM_SIZE:
        yClient = HIWORD(lParam);                                  // Retrieves the height of the client area.
        rows = yClient / 15;                                       // calculate totoal number of text row in client area
        SetScrollRange(hwnd, SB_VERT, 0, totalwords - rows, TRUE); // set scrollbar size
        InvalidateRect(hwnd, NULL, TRUE);                          // repaint window
        break;
    case WM_VSCROLL: {
        // Retrieves attributes of scrollbar
        si.cbSize = sizeof(si);
        si.fMask = SIF_ALL;
        GetScrollInfo(hwnd, SB_VERT, &si);
        // respond to scrollbar messages
        switch (LOWORD(wParam)) {
        // User clicked the HOME keyboard key.
        case SB_TOP:
            si.nPos = si.nMin;
            break;
        // User clicked the END keyboard key.
        case SB_BOTTOM:
            si.nPos = si.nMax;
            break;
        // User clicked the top arrow.
        case SB_LINEUP:
            si.nPos -= 1;
            break;
        // User clicked the bottom arrow.
        case SB_LINEDOWN:
            si.nPos += 1;
            break;
        // User dragged the scroll box.
        case SB_THUMBTRACK:
            si.nPos = si.nTrackPos;
            break;
        default:
            break;
        }
        // Set the new scollbar position.
        si.fMask = SIF_POS;
        SetScrollInfo(hwnd, SB_VERT, &si, TRUE);
        // redraw window contents by manually sending manually sending WM_PAINT
        InvalidateRect(hwnd, NULL, TRUE);
    } break;
    case WM_CLOSE:
        DestroyWindow(hwnd);
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}
