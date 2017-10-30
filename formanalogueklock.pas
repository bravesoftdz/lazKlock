unit formAnalogueKlock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, dtthemedclock, DTAnalogClock, Forms, Controls,
  Graphics, Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls, windows, formAbout;

const
  LWA_COLORKEY = 1;
  LWA_ALPHA = 2;
  LWA_BOTH = 3;
  WS_EX_LAYERED = $80000;
  GWL_EXSTYLE = -20;

{Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal Color As Long, ByVal X As Byte, ByVal alpha As Long) As Boolean }
 function SetLayeredWindowAttributes (hWnd:Longint; Color:Longint; X:Byte; alpha:Longint):bool stdcall; external 'USER32';

 {not sure how to alias these functions here ????   alias setwindowlonga!!}
 {Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long }
 Function SetWindowLongA (hWnd:Longint; nIndex:longint; dwNewLong:longint):longint stdcall; external 'USER32';


 {Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long }
 Function GetWindowLongA ( hWnd:Longint; nIndex:longint):longint stdcall; external 'user32';

type

  { TfrmAnalogueKlock }

  TfrmAnalogueKlock = class(TForm)
    DTThemedClock1: TDTThemedClock;
    MnItmAbout: TMenuItem;
    MnItmExit: TMenuItem;
    popUpMenuAnalogueKlock: TPopupMenu;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MnItmAboutClick(Sender: TObject);
    procedure MnItmExitClick(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public
    moveAnalogueKlock: Boolean;
  end;

var
  frmAnalogueKlock: TfrmAnalogueKlock;

implementation

{$R *.lfm}

uses
  formklock;


{ TfrmAnalogueKlock }

procedure SetTranslucent(ThehWnd: Longint; Color: Longint; nTrans: Integer);
{  Used to make the form transparen.

   See http://lazplanet.blogspot.co.uk/2013/04/make-your-forms-transparent.html
}
var
attrib:longint;
begin

    {SetWindowLong and SetLayeredWindowAttributes are API functions, see MSDN for details }
    attrib := GetWindowLongA(ThehWnd, GWL_EXSTYLE);
    SetWindowLongA (ThehWnd, GWL_EXSTYLE, attrib Or WS_EX_LAYERED);

    {anything with color value color will completely disappear if flag = 1 or flag = 3  }
    SetLayeredWindowAttributes (ThehWnd, Color, nTrans,1);
end;

procedure TfrmAnalogueKlock.FormCreate(Sender: TObject);
{  On form create set up transparacy stuff.  }
VAR
  transparency:longint;
begin
  {the color were going to make transparent the red that the form backgroud is set to}
  transparency :=  clBlack;

  {call the function to do it}
  SetTranslucent(frmAnalogueKlock.Handle, transparency, 0);
end;

procedure TfrmAnalogueKlock.MnItmExitClick(Sender: TObject);
{  When exiting the analogue klock, kill off the tray icon and restore the main klock.
}
begin
  frmMain.TrayIcon.Visible := false;
  frmMain.TrayIcon.Hide;

  frmMain.Visible := true;

  frmAnalogueKlock.close;

  if userOptions.analogueScreenSave then
  begin
    userOptions.analogueFormLeft := frmAnalogueKlock.Left;
    userOptions.analogueFormTop := frmAnalogueKlock.Top;
  end;
end;

procedure TfrmAnalogueKlock.FormShow(Sender: TObject);
{  When starting the analogue klock, start the tray icon and hide the main klock.  }
begin
  frmMain.TrayIcon.Visible := True;
  frmMain.TrayIcon.Show ;

  frmMain.Visible := false;

  if userOptions.analogueScreenSave then
  begin
    frmAnalogueKlock.Left := userOptions.analogueFormLeft;
    frmAnalogueKlock.Top := userOptions.analogueFormTop;
  end;
end;

procedure TfrmAnalogueKlock.MnItmAboutClick(Sender: TObject);
{  Load the about page.  }
begin
  frmAbout.show;
end;

procedure TfrmAnalogueKlock.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{  update mouse position when form is dragged i.e. left mouse button down  }
begin
  moveAnalogueKlock := True;
end;

procedure TfrmAnalogueKlock.Shape1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
{  make klock follow the mouse, when left button is held down.  }
begin
  if moveAnalogueKlock then
  begin
    frmAnalogueKlock.Left := mouse.CursorPos.x - height;
    frmAnalogueKlock.Top := mouse.CursorPos.y - width;
  end;
end;

procedure TfrmAnalogueKlock.Shape1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{  Left mouse button released, stop dragging.  }
begin
  moveAnalogueKlock := False;
end;

end.
