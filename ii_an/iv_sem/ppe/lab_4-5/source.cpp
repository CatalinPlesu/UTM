#include <tchar.h>
#include <windows.h>

#define PUSH_BUTTON (WM_APP + 1)
#define TIMER (WM_APP + 2)
#define TOTAL_TIME 120000 // 2 min
/* #define TOTAL_TIME 1200 // 2 min */

static TCHAR szWindowClass[] = _T("DesktopApp");
static TCHAR szTitle[] = _T("Plesu Catalin lab 4-5 PPE");


HINSTANCE hInst;

int yClient;
int total_scroll_points = 100;

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

int CALLBACK WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance,
    _In_ LPSTR lpCmdLine, _In_ int nCmdShow)
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
        MessageBox(NULL, _T("Call to RegisterClassEx failed!"),
            _T("Windows Desktop Guided Tour"), NULL);
        return 1;
    }

    hInst = hInstance;
    HWND hwnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW | WS_VSCROLL,
        0, 0, 500, 550, NULL, NULL, hInstance, NULL);

    if (!hwnd) {
        MessageBox(NULL, _T("Call to CreateWindow failed!"),
            _T("Windows Desktop Guided Tour"), NULL);
        return 1;
    }

    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return (int)msg.wParam;
}

#define winmacro(text, style) CreateWindow(TEXT("button"), TEXT(text), \
            WS_CHILD | WS_VISIBLE |  ES_LEFT | style, \
            10, y+=20, 400, 20, \
            hwnd, NULL, ((LPCREATESTRUCT)lParam)->hInstance, NULL)

LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wParam,
    LPARAM lParam)
{
    PAINTSTRUCT ps;
    SCROLLINFO si;
    HDC hdc;

    switch (message) {
    case WM_TIMER:
        KillTimer(hwnd, TIMER);

        MessageBox(NULL,
            TEXT("Timpul a expirat!"),
            TEXT("Alarma"),
            MB_ICONEXCLAMATION);

        PostQuitMessage(0);
        break;
    case WM_CREATE: {
        MessageBox(NULL,
            TEXT("Vei avea la dispozitie 2 minute"),
            TEXT("Atentie"),
            MB_ICONINFORMATION);

        SetTimer(hwnd, TIMER, TOTAL_TIME, NULL);

        int y = 10;
        winmacro("Cocoa", WS_GROUP | BS_AUTORADIOBUTTON);
        winmacro("WinApi",  BS_AUTORADIOBUTTON );
        winmacro("Xlib",  BS_AUTORADIOBUTTON );
        winmacro("wayland-client",  BS_AUTORADIOBUTTON );

        y = 20*6+10;
        winmacro("NT",  WS_GROUP | BS_AUTORADIOBUTTON );
        winmacro("Linux",  BS_AUTORADIOBUTTON );
        winmacro("XNU",  BS_AUTORADIOBUTTON );

        y = 20*12+10;
        winmacro("GIMP",   BS_AUTOCHECKBOX);
        winmacro("Photoshop",   BS_AUTOCHECKBOX);
        winmacro("Emacs",   BS_AUTOCHECKBOX);
        winmacro("Cat",   BS_AUTOCHECKBOX);
        winmacro("Vim",   BS_AUTOCHECKBOX);
        winmacro("Bash",   BS_AUTOCHECKBOX);
        winmacro("Powershell",   BS_AUTOCHECKBOX);
        winmacro("Zsh",   BS_AUTOCHECKBOX);
        winmacro("gcc",   BS_AUTOCHECKBOX);
        winmacro("wget",   BS_AUTOCHECKBOX);


        CreateWindow(
            "BUTTON", "Finiseaza", WS_VISIBLE | WS_CHILD | WS_BORDER, 10,
            500, 90, 20, hwnd, (HMENU)PUSH_BUTTON,
            ((LPCREATESTRUCT)lParam)->hInstance, NULL);
        break;
    }

    case WM_COMMAND: {
        if (wParam == PUSH_BUTTON) {

        MessageBox(NULL,
            TEXT("Testul a fost finisat"),
            TEXT("Felicitari"),
            MB_ICONINFORMATION);

        PostQuitMessage(0);
        }
        break;
    }

    case WM_PAINT: {
        hdc = BeginPaint(hwnd, &ps);

        TCHAR* intrebari[] = {
            _T("Cel mai rau API pentru interfata de utilizator din univers"),
            _T("Cel mai bun kernel"),
            _T("Programe GNU"),
        };
        TextOut(hdc, 10, 10, intrebari[0], _tcslen(intrebari[0]));
        TextOut(hdc, 10, 10 + 20*6, intrebari[1], _tcslen(intrebari[1]));
        TextOut(hdc, 10, 10 + 20*12, intrebari[2], _tcslen(intrebari[2]));

        EndPaint(hwnd, &ps);
        DeleteDC(hdc);
        break;
    }

    case WM_SIZE:
        yClient = HIWORD(lParam);

        SetScrollRange(hwnd, SB_VERT, 0, total_scroll_points, TRUE);
        InvalidateRect(hwnd, NULL, TRUE);
        break;

    case WM_VSCROLL: {
        si.cbSize = sizeof(si);
        si.fMask = SIF_ALL;
        GetScrollInfo(hwnd, SB_VERT, &si);


        switch (LOWORD(wParam)) {
        case SB_TOP:
            si.nPos = si.nMin;
            break;
        case SB_BOTTOM:
            si.nPos = si.nMax;
            break;
        case SB_LINEUP:
            si.nPos -= 1;
            break;
        case SB_LINEDOWN:
            si.nPos += 1;
            break;
        case SB_THUMBTRACK:
            si.nPos = si.nTrackPos;

        default:
            break;
        }
        // Set the new scollbar position.
        si.fMask = SIF_POS;
        SetScrollInfo(hwnd, SB_VERT, &si, TRUE);
        // redraw window contents by manually sending manually sending WM_PAINT
        InvalidateRect(hwnd, NULL, TRUE);
    } break;

    case WM_DESTROY: {
        PostQuitMessage(0);
        break;
    }
    default:
        return DefWindowProc(hwnd, message, wParam, lParam);
        break;
    }
    return 0;
}
