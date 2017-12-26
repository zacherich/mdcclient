unit sliderPanel;

interface

uses Windows, Messages, SysUtils, Classes, Graphics,Controls,StdCtrls,Dialogs,
  ExtCtrls,StrUtils,forms;

type
  TCaptionStyle = (csNormal,csHollow,csShadow);
  TSliderPanel = class(TPanel)
  private
    FOnLoop:TNotifyEvent;
    FOnChange:TNotifyEvent;
    FTopNow:integer;
    FScrollSpeed: integer;
    FTimer: TTimer;
    FLines: TStringList;
    FDealStrings:boolean;
    FAlignment :TAlignment;
    FCaptionStyle :TCaptionStyle;
    FActive :Boolean;

    Initial:boolean;
    TxtHeight:integer;
    FXOffSet :array of integer;

    procedure SetLines (Value: TStringList);
    procedure SetCaptionStyle (Value: TCaptionStyle);
    procedure SetActive (Value: boolean);
    procedure SetAlignment (Value: TAlignment);
    procedure SetScrollSpeed (Value: integer);
    procedure Timer(Sender: TObject);
    procedure LinesChanged(Sender: TObject);
    procedure toPAINTtxt;
  protected
    procedure Resize;override;
    procedure Paint;OverRide;
  public
    constructor Create (AOwner: TComponent); override;
    destructor  Destroy ; override;
  published
    property Active: Boolean read FActive write SetActive default true;
    property CaptionStyle: TCaptionStyle read FCaptionStyle  write SetCaptionStyle default csNormal;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;

    property Lines: TStringList read FLines write SetLines;

    //文字滚动速度控制，单位是毫秒
    property ScrollSpeed: integer read FScrollSpeed write SetScrollSpeed default 10;
    property OnLoop: TNotifyEvent read FOnLoop write FOnLoop;
  end;

procedure Register;

implementation

Const
   constStopMess :String = '已经停止滚动！';

procedure Register;
begin
  RegisterComponents('Arhaha', [TSliderPanel]);
  showmessage('The TSliderPanel component is made by Arhaha 2002-07');
end;

{ **************************************************************************** }

procedure TSliderPanel.paint;
var
   OutMess:string;
begin
      //*******
      //inherited;

      SetBKMode(canvas.Handle,windows.TRANSPARENT);
      //
      if self.FTimer.enabled then
         OutMess :=Caption
      else
         OutMess :=constStopMess;

      canvas.Brush.Color := self.Color;
      Canvas.FillRect(self.ClientRect);

      canvas.Font.name := '宋体';
      canvas.Font.Size := self.Font.Size + 16;
      canvas.Font.Style := [fsBold,fsItalic];
      if FCaptionStyle = csHollow then
      begin
         beginpath(canvas.handle);
         SetBkMode( Canvas.Handle, TRANSPARENT );
      end;
      if FCaptionStyle = csShadow then
      begin
         canvas.Font.Color := cl3DDKShadow;
         canvas.TextOut((self.Width - canvas.TextWidth(OutMess)) * 5 div 11 + 1,(self.height - canvas.Textheight(OutMess)) div 2 + 1,OutMess);
      end;
      canvas.Font.Color := clBtnFace;
      canvas.TextOut((self.Width - canvas.TextWidth(OutMess)) * 5 div 11,(self.height - canvas.Textheight(OutMess)) div 2,OutMess);
      if FCaptionStyle = csHollow then
      begin
          endpath(canvas.handle);
          Canvas.Pen.Color := clBtnFace;
          StrokePath(canvas.handle); //将捕获的轮廓用当前的Pen画到Canvas上
      end;

      canvas.Font := self.Font;

      toPAINTtxt;

end;

{ **************************************************************************** }

procedure TSliderPanel.toPAINTtxt;// Repaint the control ...
var
  YOffset,YOffset1,iLoop:integer;
     OutMess:string;
begin
      if FDealStrings then exit;
      if Initial and (self.Lines.Count = high(FXOffSet)+1) then
      begin
          YOffSet := height - FTopNow;
          for iLoop:=0 to self.Lines.Count - 1 do
          begin
              YOffSet1 := YOffSet + TxtHeight;
              if (YOffSet1>0) and (YOffSet<height) then
                  Canvas.textout(FXOffSet[iLoop],YOffSet,self.Lines[iLoop]);
              YOffSet := YOffSet1;
          end;
      end;
end;
{ **************************************************************************** }

procedure TSliderPanel.Timer(Sender: TObject);
begin
  if not Initial then
  begin
     Canvas.Font := self.Font;
     FTopNow := self.Height;
     TxtHeight := Canvas.textheight('Pg哈');
     self.TabStop := false;
     Canvas.Brush.Color := self.Color;

     Initial := true;
  end else
     invalidate;

  FTopNow := FTopNow + 1;
  if FTopNow>(height+TxtHeight*Self.Lines.Count) then
  begin
    FTopNow :=0;
    if assigned(FOnLoop) then
    begin
       FTimer.Enabled := false;
       FOnLoop(Self);
       FTimer.Enabled := true;
    end;
  end;
end;

{ **************************************************************************** }

procedure TSliderPanel.SetCaptionStyle (Value: TCaptionStyle);
begin
   if FCaptionStyle <> value then
   begin
      FCaptionStyle := value;
      invalidate;
   end;
end;

{ **************************************************************************** }

procedure TSliderPanel.SetActive (Value: boolean);
begin
   if FActive <> value then
   begin
        FActive := value;
        FTimer.Enabled := value;
        invalidate;
   end;
end;

{ **************************************************************************** }

constructor TSliderPanel.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  ControlStyle := ControlStyle + [csOpaque];

  FScrollSpeed :=50;
  FTimer := TTimer.create(self);
  FTImer.Interval :=FScrollSpeed;// ;
  FTimer.ontimer := timer;
  Initial := false;
  self.Cursor := crArrow;
  FLines := TStringList.Create;
  FLines.onchange := LinesChanged;
  FActive := true;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  BorderStyle := bsSingle;

  if (FTimer.Interval<1) or (csDesigning in ComponentState) then
  begin
      //FTimer.Enabled := false;
  end;

end;

{ **************************************************************************** }

destructor  TSliderPanel.Destroy;
begin
   FTimer.free;
   FLines.Free;
   inherited;
end;

{ **************************************************************************** }
 procedure TSliderPanel.SetScrollSpeed (Value: integer);
 begin
  if value>=0 then
  begin
    FScrollSpeed := Value;
    FTimer.Interval := value;
    Refresh;
  end else
    ShowMessage('ScrollSpeed must be greater than -1!');
 end;

 { **************************************************************************** }

 procedure TSliderPanel.SetLines (Value: TStringList);
 begin
   FLines.Assign(value);
 end;

   { **************************************************************************** }

 procedure TSliderPanel.SetAlignment(Value: TAlignment);
 begin
    if  FAlignment <> value then
    begin
      FAlignment := value;
      LinesChanged(self);
      refresh;
    end;
 end;


 { **************************************************************************** }

 procedure TSliderPanel.ReSize;
 var
   iLoop:integer;
 begin
   inherited ReSize;
   iLoop := TxtHeight + 10;
   if (self.Height<iLoop) or (self.Width < iLoop) then exit;
   FDealStrings := true;
   for iLoop :=1 to self.Lines.Count - 1 do
   begin
       if (csDesigning in ComponentState) and ((rightstr(self.Lines[0],1)<>#10)) or (length(self.Lines[1])=0) then
          self.Lines[0] := self.Lines[0]+#13#10 + self.Lines[1]
       else
          self.Lines[0] := self.Lines[0] + self.Lines[1];

       self.Lines.Delete(1);
   end;
   FDealStrings := false;
   LinesChanged(self);
 end;

 { **************************************************************************** }


 procedure TSliderPanel.LinesChanged(Sender: TObject);
 var
   iLoop,iInnerLoop,iPos,iWidth:integer;
   anstr:widestring;
   temps:string;
 begin
   //
   if FDealStrings then exit;

   FDealStrings := true;
   //////处理换行符
   iLoop:=0;
   while iLoop < self.Lines.Count do
   begin
       temps := self.Lines[iLoop];
       iPos := pos(#13#10,temps);
       inc(iLoop);
       if (iPos>0) and ((iPos + 1) < length(temps)) then
       begin
          self.Lines[iLoop - 1]:=leftstr(temps,iPos + 1);
          self.Lines.Insert(iLoop,rightstr(temps,length(temps) -iPos -1));
       end;
   end;

   iLoop := 0;
   while iLoop<self.Lines.Count do
   begin
       anstr := widestring(self.Lines[iLoop]);
       inc(iLoop);
       if canvas.TextWidth(anstr)>self.ClientWidth then
       begin
          iWidth := 0;
          for iInnerLoop := 1 to length(anstr) do
          begin
             if anstr[iInnerLoop]=#13 then break;
             iWidth := iWidth + self.Canvas.TextWidth(anstr[iInnerLoop]);
             if (iWidth > self.ClientWidth) then
             begin
                 temps := '';
                 for iPos :=1 to iInnerLoop -1 do temps := temps + anstr[iPos];
                 self.Lines[iLoop - 1] := temps;

                 temps := '';
                 for iPos := length(anstr) downto iInnerLoop do temps := anstr[iPos] + temps;
                 self.Lines.Insert(iLoop,temps);
                 break;
             end;
          end;
       end;
   end;

   /////计算显示位置的X位移
   iPos :=  self.Lines.Count;
   if iPos>0 then
   begin
       setlength(FXOffSet,iPos);
       //self.Canvas.TextOut(100,100,'aaaa');
       for iLoop :=0  to iPos -1 do
       begin
           iWidth := self.Canvas.TextWidth( self.Lines[iLoop]);
           if FAlignment = taLeftJustify then
           begin
              FXOffSet[iLoop] := 0;
           end else if FAlignment = taRightJustify then
           begin
              FXOffSet[iLoop] :=self.ClientWidth  - iWidth;
           end else
           begin
              FXOffSet[iLoop] := (self.ClientWidth - iWidth) div 2;
           end;
       end;
   end;

   if assigned(FOnChange) then FonChange(Self);
   FDealStrings := false;
   //
   toPAINTtxt;
 end;

  { **************************************************************************** }

end.
