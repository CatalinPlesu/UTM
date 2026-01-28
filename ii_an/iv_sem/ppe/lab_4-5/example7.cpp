#include <windows.h>
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
#define ID_CHANGE_TITLE 1
#define ID_QUIT_WINDOW 2
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR lpCmdLine, int nCmdShow)
{
    MSG msg;
    WNDCLASSW wc = { 0 };
    wc.lpszClassName = L"Original title";
    wc.hInstance = hInstance;
    wc.hbrBackground = GetSysColorBrush(COLOR_3DFACE);
    wc.lpfnWndProc = WndProc;
    wc.hCursor = LoadCursor(0, IDC_ARROW);
    RegisterClassW(&wc);
    CreateWindowW(wc.lpszClassName, L"Buttons", WS_OVERLAPPEDWINDOW | WS_VISIBLE, 150, 150, 250, 200, 0, 0, hInstance, 0);
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return (int)msg.wParam;
}
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch (msg) {
    case WM_CREATE:
        // creates child window change title button
        CreateWindowW(L"BUTTON", L"change title", WS_VISIBLE | WS_CHILD, 20, 50, 80, 25, hwnd, (HMENU)ID_CHANGE_TITLE, NULL, NULL);
        // creates child window close
        CreateWindowW(L"BUTTON", L"Close ", WS_VISIBLE | WS_CHILD, 120, 50, 80, 25, hwnd, (HMENU)ID_QUIT_WINDOW, NULL, NULL);
        break;
    case WM_COMMAND:
        // when a button is clicked a WM_COMMAND message is sent to the parent window procedure.
        if (LOWORD(wParam) == ID_CHANGE_TITLE) {
            SetWindowTextW(hwnd, L"new title"); // api function to set main windows title
        }
        if (LOWORD(wParam) == ID_QUIT_WINDOW) {
            PostQuitMessage(0);
        }
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    }
    return DefWindowProcW(hwnd, msg, wParam, lParam);
}
