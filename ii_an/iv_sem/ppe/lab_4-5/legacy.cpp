#include <algorithm>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <tchar.h>
#include <vector>
#include <windows.h>

#define TESTNAME "test.txt"
#define CCHAR '*'

typedef struct {
    std::string question;
    std::vector<std::string> answers;
    std::vector<int> correct;
} test_item;

std::vector<test_item> read_test()
{
    std::vector<test_item> test;

    std::string line;
    std::ifstream myfile(TESTNAME);
    bool b_question = true;
    if (myfile.is_open()) {
        test_item new_test_item;
        int answer_index = 0;
        while (getline(myfile, line)) {
            if (b_question) {
                new_test_item.question = line;
                b_question = false;
            } else if (line.length() == 0) {
                b_question = true;
                answer_index = 0;
                if (new_test_item.question.length() != 0)
                    test.push_back(new_test_item);
                new_test_item = {};
            } else {
                if (line.find(CCHAR) != std::string::npos) {
                    line.replace(line.find(CCHAR), 1, "");
                    new_test_item.correct.push_back(answer_index);
                }
                new_test_item.answers.push_back(line);
                answer_index++;
            }
        }
        if (new_test_item.question.length() != 0)
            test.push_back(new_test_item);
        myfile.close();
    } else
        std::cout << "Unable to open file";

    return test;
}

TCHAR* str_to_tchr(std::string str)
{
    TCHAR* param = new TCHAR[str.size() + 1];
    param[str.size()] = 0;
    std::copy(str.begin(), str.end(), param);
    return param;
}

/* int main() */
/* { */
/*     std::vector<test_item> test = read_test(); */

/*     for (int i = 0; i < test.size(); i++) { */
/*         std::cout << "Q " << test[i].question << std::endl; */
/*         for (int j = 0; j < test[i].answers.size(); j++) { */
/*             std::vector<int> v = test[i].correct; */
/*             if (std::find(v.begin(), v.end(), j) != v.end()) { */
/*                 std::cout << "C"; */
/*             } else { */
/*                 /1* v does not contain x *1/ */
/*             } */
/*             std::cout << "\tA " << test[i].answers[j] << std::endl; */
/*         } */
/*     } */

/*     return 0; */
/* } */

std::vector<test_item> test = read_test();

static TCHAR szWindowClass[] = _T("DesktopApp");
static TCHAR szTitle[] = _T("Plesu Catalin lab 4-5 PPE");

// use WM_APP + x
#define WM_PUSHBUTTON_START (WM_APP + 1)
#define WM_PUSHBUTTON_FINISH (WM_APP + 2)
#define WM_INPUT_NAME (WM_APP + 3)
#define WM_ANSWERS (WM_APP + 4)
#define WM_ANSWER_OFFSET (WM_APP + 100)

HINSTANCE hInst;
HWND TextBox, SendButton, FinishButton;
HWND hwndAnswers[10];

bool started = false;
TCHAR username[128];
float percents = 100;
int yClient;
int totalquestoins = test.size() - 1;
int yPos = 0;
TCHAR* answer;

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
void print_answers(HWND, LPARAM);

#define windowMacro(text, style, i)                                            \
    hwndAnswers[i - 1] = NULL;                                                 \
    hwndAnswers[i - 1] = CreateWindow(                                         \
        "BUTTON", text, WS_CHILD | WS_VISIBLE | style, 10, 90 + 20 * (i), 400, \
        20, hwnd, (HMENU)(WM_ANSWER_OFFSET + i),                               \
        ((LPCREATESTRUCT)lParam)->hInstance, NULL)

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

    /* MessageBox(NULL, */
    /*     TEXT("Timpul a expirat!"), */
    /*     TEXT("Atentie"), */
    /*     MB_ICONEXCLAMATION); */

    /* MessageBox(NULL, */
    /*     TEXT("Testul a fost preluat"), */
    /*     TEXT("Finisat"), */
    /*     MB_ICONINFORMATION); */

    hInst = hInstance;
    HWND hwnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW | WS_VSCROLL,
        500, 500, 500, 500, NULL, NULL, hInstance, NULL);

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

void print_answers(HWND hwnd, LPARAM lParam)
{
    int len = test[yPos].answers.size();
    int correct = test[yPos].correct.size();
    int i = 0;
    int ASTYL = (correct == 1) ? BS_AUTORADIOBUTTON : BS_AUTOCHECKBOX;

    switch (len) {
    case 10:
        i = 10;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 9 : 
        i = 9;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 8 : 
        i = 8;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 7 : 
        i = 7;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 6 : 
        i = 6;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 5 : 
        i = 5;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 4 : 
        i = 4;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 3 : 
        i = 3;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 2 : 
        i = 2;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    case 1 : 
        i = 1;
        answer = str_to_tchr(test[yPos].answers[i - 1]);
        windowMacro(answer, ASTYL, i);
    break;
    default:
        break;
    }
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT message, WPARAM wParam,
    LPARAM lParam)
{
    PAINTSTRUCT ps;
    SCROLLINFO si;
    HDC hdc;

    switch (message) {
    case WM_CREATE: {
        if (!started) {
            TextBox = CreateWindow("EDIT", "", WS_BORDER | WS_CHILD | WS_VISIBLE, 10,
                60, 300, 20, hwnd, (HMENU)WM_INPUT_NAME,
                ((LPCREATESTRUCT)lParam)->hInstance, NULL);

            SendButton = CreateWindow("BUTTON", "Incepe", WS_VISIBLE | WS_CHILD | WS_BORDER,
                310, 60, 65, 20, hwnd, (HMENU)WM_PUSHBUTTON_START,
                ((LPCREATESTRUCT)lParam)->hInstance, NULL);
        }
        break;
    }

    case WM_COMMAND: {
        if (wParam == WM_PUSHBUTTON_START) {
            GetWindowText(TextBox, username, 128);
            std::cout << "test started " << username << std::endl;
            DestroyWindow(TextBox);
            DestroyWindow(SendButton);
            started = true;

            print_answers(hwnd, lParam);

            FinishButton = CreateWindow(
                "BUTTON", "Finiseaza", WS_VISIBLE | WS_CHILD | WS_BORDER, 10,
                yClient - 50, 90, 20, hwnd, (HMENU)WM_PUSHBUTTON_FINISH,
                ((LPCREATESTRUCT)lParam)->hInstance, NULL);

            InvalidateRect(hwnd, NULL, TRUE);
        }

        if (wParam == WM_ANSWERS) {
            std::cout << "should redraw answers\n";
            print_answers(hwnd, lParam);
            InvalidateRect(hwnd, NULL, TRUE);
        }

        if (wParam == WM_PUSHBUTTON_FINISH) {
            std::cout << "test finished " << username << std::endl;

            DestroyWindow(hwndAnswers[0]);
            DestroyWindow(hwndAnswers[1]);
            DestroyWindow(hwndAnswers[2]);
            DestroyWindow(hwndAnswers[3]);
            DestroyWindow(hwndAnswers[4]);
            DestroyWindow(hwndAnswers[5]);
            DestroyWindow(hwndAnswers[6]);
            DestroyWindow(hwndAnswers[7]);
            DestroyWindow(hwndAnswers[8]);
            DestroyWindow(hwndAnswers[9]);

            InvalidateRect(hwnd, NULL, TRUE);
        }

        if (wParam == (WM_ANSWER_OFFSET + 1)) {
            std::cout << "answer " << 1 << " clicked\n";
        }
        if (wParam == (WM_ANSWER_OFFSET + 2)) {
            std::cout << "answer " << 2 << " clicked\n";
        }

        break;
    }

    case WM_PAINT: {
        hdc = BeginPaint(hwnd, &ps);

        if (!started) {
            TCHAR* textes[] = {
                _T("Testul dat va dura 10 min"),
                _T("Introduceti numele si prenumele dvs."),
            };
            TextOut(hdc, 10, 10, textes[0], _tcslen(textes[0]));
            TextOut(hdc, 10, 30, textes[1], _tcslen(textes[1]));
        } else {
            yPos = GetScrollPos(hwnd, SB_VERT);
            TCHAR sbv[128] = TEXT("\0");
            wsprintf(sbv, TEXT("Utilizatorul curent: %s; Timpul ramas: %d s"),
                username, 60);
            TextOut(hdc, 10, 10, sbv, _tcslen(sbv));

            TCHAR* question = str_to_tchr(test[yPos].question);
            TextOut(hdc, 10, 90, question, _tcslen(question));
        }

        EndPaint(hwnd, &ps);
        DeleteDC(hdc);
        break;
    }

    case WM_SIZE:
        yClient = HIWORD(lParam);
        SetWindowPos(FinishButton, NULL, 0, yClient - 20, 90, 20, SWP_SHOWWINDOW);
        SetScrollRange(hwnd, SB_VERT, 0, totalquestoins, TRUE);
        InvalidateRect(hwnd, NULL, TRUE);
        break;
    case WM_VSCROLL: {
        si.cbSize = sizeof(si);
        si.fMask = SIF_ALL;
        GetScrollInfo(hwnd, SB_VERT, &si);

        if (started) {
            DestroyWindow(hwndAnswers[0]);
            DestroyWindow(hwndAnswers[1]);
            DestroyWindow(hwndAnswers[2]);
            DestroyWindow(hwndAnswers[3]);
            DestroyWindow(hwndAnswers[4]);
            DestroyWindow(hwndAnswers[5]);
            DestroyWindow(hwndAnswers[6]);
            DestroyWindow(hwndAnswers[7]);
            DestroyWindow(hwndAnswers[8]);
            DestroyWindow(hwndAnswers[9]);
            PostMessage(hwnd, WM_COMMAND, WM_ANSWERS, NULL);
        }

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
