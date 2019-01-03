; compile with: 
; nasm -fwin32 CreateProcessA.asm && GoLink.exe /entry _main kernel32.dll user32.dll -o CreateProcessA.obj && CreateProcessA.exe
%define NULL 0
%define TRUE 1
%define FALSE 0 
%define CREATE_NO_WINDOW 0x8
%define MB_OK 0

;https://docs.microsoft.com/en-us/windows/desktop/api/processthreadsapi/ns-processthreadsapi-_startupinfoa
STRUC STARTUPINFO
	.cb RESD 1
	.lpReserved RESD 1
	.lpDesktop RESD 1
	.lpTitle RESD 1
	.dwX RESD 1
	.dwY RESD 1
	.dwXSize RESD 1
	.dwYSize RESD 1
	.dwXCountChars RESD 1
	.dwYCountChars RESD 1
	.dwFillAttribute RESD 1
	.dwFlags RESD 1
	.wShowWindow RESW 1
	.cbReserved2 RESW 1
	.lpReserved2 RESD 1
	.hStdInput RESD 1
	.hStdOutput RESD 1
	.hStdError RESD 1
ENDSTRUC

;https://msdn.microsoft.com/zh-cn/dynamics/ms684873(v=vs.90)
STRUC PROCESS_INFORMATION
	.hProcess RESD 1
	.hThread RESD 1
	.dwProcessId RESD 1
	.dwThreadId RESD 1
ENDSTRUC

extern CreateProcessA
;BOOL CreateProcessA(
;  LPCSTR                lpApplicationName,
;  LPSTR                 lpCommandLine,
;  LPSECURITY_ATTRIBUTES lpProcessAttributes,
;  LPSECURITY_ATTRIBUTES lpThreadAttributes,
;  BOOL                  bInheritHandles,
;  DWORD                 dwCreationFlags,
;  LPVOID                lpEnvironment,
;  LPCSTR                lpCurrentDirectory,
;  LPSTARTUPINFOA        lpStartupInfo,
;  LPPROCESS_INFORMATION lpProcessInformation
;);
extern MessageBoxA
;int MessageBox(
;  HWND    hWnd,
;  LPCTSTR lpText,
;  LPCTSTR lpCaption,
;  UINT    uType
;);

extern ExitProcess
;void ExitProcess(
;  UINT uExitCode
;);


global _main

section .data

startinfo:
	istruc STARTUPINFO
iend

processinfo:
	istruc PROCESS_INFORMATION
iend

section .text

	command: db "calc.exe",0
	msg_box: db "calc.exe executed!",0
	title: 	 db "hello",0

_main:
	call exec_calc
	call box
	call exit

exec_calc:
	push dword processinfo
	push dword startinfo
	push dword NULL
	push dword NULL
	push dword CREATE_NO_WINDOW
	push dword FALSE
	push dword NULL
	push dword NULL
	push dword command
	push dword NULL
	call CreateProcessA           ;; launch calc.exe
	ret

box:
	push dword MB_OK
	push dword title
	push dword msg_box
	push dword NULL
	call MessageBoxA			  ;; launch MessageBox
	ret

exit:
	push dword 0
	call ExitProcess              ;; exit out
