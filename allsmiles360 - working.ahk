#SingleInstance force
#Persistent
SetTitleMatchMode 2
SetWorkingDir %A_ScriptDir%

watch_originals := "C:\AllSmiles360\watch_originals.ps1"
run, powershell.exe %watch_originals%

run, dslrbooth.ahk

SetTimer, Watchdog, 10000
SetTimer, Animate, 50000


;WATCH FOR 4 .JPGS
Watchdog:
;soundplay, C:\Users\Nicholas\Pictures\dslrBooth\cropped\unlock.wav  ;fucking obnoxious sound, indicative of successful run


  count=0
  loop,C:\Users\Nicholas\Pictures\dslrBooth\cropped\*.jpg
    files:=(files ? "`n" : "") . A_LoopFileFullPath,count:=count+1
        if count >= 4
       {

;RUN IRFANVIEW TO CREATE LONG PANORAMA FROM 4 CAPTURES
    run, %comspec% /k ,,,pid1
    WinWaitActive, %ComSpec% ahk_pid %PID1%,, hide

      sendInput cd C:\Program Files (x86)\IrfanView {Enter}
      sendInput i_view32.exe /panorama=(1,C:\Users\Nicholas\Pictures\dslrBooth\cropped\*.jpg) /convert="C:\Users\Nicholas\Pictures\dslrBooth\cropped\panorama.jpg" {Enter}
      sendInput exit {Enter}

          sleep, 100
          FormatTime, TimeString,, MMddyyyymmss
          Filemove, C:\Users\Nicholas\Pictures\dslrBooth\cropped\panorama.jpg, C:\Users\Nicholas\Pictures\dslrBooth\cropped\panoramas\panorama-%TimeString%.jpg

          IfNotExist, %TimeString%s\dslrBooth\cropped\*.jpg) /convert="C:\Users\Nicholas\Picturzes\dslrBooth\cropped\panorama.jpg"
             FileCreateDir, %TimeString%
          Filemove, C:\Users\Nicholas\Pictures\dslrBooth\cropped\*.jpg, C:\Users\Nicholas\Pictures\dslrBooth\cropped\%TimeString%
          Filemove, C:\Users\Nicholas\Pictures\dslrBooth\Originals\*.jpg, C:\Users\Nicholas\Pictures\dslrBooth\Unedited
          }

          else
          {
          sleep, 100
          }

	return

;OPEN WPANO GUI TO CREATE RTL PANORAMIC VIDEO
Animate:
Run, "C:\Program Files (x86)\WPanorama\WPanorama.exe"
WinSet, Bottom, , ahk_class  TfrmWPanorama
sleep, 5000
IfWinExist, WPanorama  panorama
    WinActivate ; use the window found above

	send {alt}fl
	sleep, 1000
	send {enter}
	Send {shift}{tab}{space}
	Send {enter}
	sleep, 1000

IfWinExist, WPanorama  panorama
    WinActivate ; use the window found above

	send {alt}am
	sleep, 100
	send 10
	sleep, 100
	send {enter}
	sleep, 100
	#IfWinExist, , Capture
	send {enter}

run, dslrbooth.ahk
