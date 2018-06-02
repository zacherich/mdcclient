unit frmInspect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, DBClient, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  Tfrm_Inspect = class(TForm)
    dbg_inspect: TDBGrid;
    spb_close: TSpeedButton;
    spb_save: TSpeedButton;
    edt_fixture: TEdit;
    lbl_tag_fixture: TLabel;
    gpl_top: TGridPanel;
    lbl_tag_wo: TLabel;
    lbl_wo: TLabel;
    lbl_tag_product_code: TLabel;
    lbl_product_code: TLabel;
    pnl_middle: TPanel;
    gpl_middle: TGridPanel;
    lbl_tag_qty: TLabel;
    lbl_qty: TLabel;
    pnl_result: TPanel;
    procedure spb_saveClick(Sender: TObject);
    procedure dbg_inspectDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure spb_closeClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure dbg_inspectKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure dbg_inspectKeyPress(Sender: TObject; var Key: Char);
    procedure InspectionOK;
    procedure InspectionNG;
    procedure InspectionUnclock; //IPQC解锁
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function InspectToJson(vDataset: TClientDataSet): String;

var
  frm_Inspect: Tfrm_Inspect;
  uvIInput : String = '';
  uvIStart : DWORD;
  uvInput_count  : Integer = 1;
  uvLast_one : Bool = False;

implementation

uses frmMain, dataModule, publicLib, SuperObject;

{$R *.dfm}

procedure Tfrm_Inspect.InspectionOK; //检查NG
begin
  lbl_tag_qty.Font.Color := clWhite;
  lbl_qty.Font.Color := clWhite;
  pnl_result.Font.Color := clWhite;
  pnl_result.Color := clGreen;
  pnl_middle.Color := clGreen;
  case frm_main.rdg_unproductive.ItemIndex of
  -1..1:    //正常生产的产量算作正常生产
    begin

    end;
  2:     //首件检查OK
    begin
      if uvInput_count<gvFirst_count then
        begin
          lbl_qty.Caption := IntToStr(uvInput_count) + '/' + IntToStr(gvFirst_count);
          log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完成' + lbl_qty.Caption + '首件记录。');
          with data_module.cds_inspect do
            begin
              if RecordCount>0 then
                begin
                  First;
                  while not Eof do
                    begin
                      Edit;
                      FieldByName('value').AsWideString := '';
                      FieldByName('note').AsWideString := '';
                      Post;
                      Next;
                    end;
                  First;
                end;
            end;
          edt_fixture.Text := '';
          pnl_result.Caption := '首件检查OK！！！';
          uvLast_one := False;
          Inc(uvInput_count);
        end
      else
        begin
          log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完成' + IntToStr(uvInput_count) + '/' + IntToStr(gvFirst_count) + '首件记录。');
          frm_main.rdg_unproductive.ItemIndex := -1;
          uvLast_one := True;
          self.Close;
          uvInput_count := 1;
        end;
    end;
  3:     //抽检检查OK
    begin
      lbl_qty.Caption :=  '1/1';
      log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完' + lbl_qty.Caption + '抽检记录。');
      pnl_result.Caption := '抽检检查OK！！！';
      frm_main.rdg_unproductive.ItemIndex := -1;
      self.Close;
      uvInput_count := 1;
    end;
  4:     //末件检查OK
    begin
      lbl_qty.Caption :=  '1/1';
      log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完成' + lbl_qty.Caption + '末件记录。');
      pnl_result.Caption := '末件检查OK！！！';
      frm_main.rdg_unproductive.ItemIndex := -1;
      self.Close;
      uvInput_count := 1;
    end;
  end;
end;

procedure Tfrm_Inspect.InspectionNG; //检查NG
begin
  lbl_tag_qty.Font.Color := clWhite;
  lbl_qty.Font.Color := clWhite;
  pnl_result.Font.Color := clWhite;
  pnl_result.Color := clRed;
  pnl_middle.Color := clRed;
  case frm_main.rdg_unproductive.ItemIndex of
  -1..1:    //正常生产的产量算作正常生产
    begin

    end;
  2:     //首件检查NG
    begin
      if uvInput_count<gvFirst_count then
        begin
          lbl_qty.Caption := IntToStr(uvInput_count)+ '/' + IntToStr(gvFirst_count);
          uvLast_one := False;
          Inc(uvInput_count);
        end
      else
        begin
          lbl_qty.Caption := IntToStr(uvInput_count)+ '/' + IntToStr(gvFirst_count);
          uvLast_one := True;
          uvInput_count := 1;
        end;
      pnl_result.Caption := '首件NG，设备锁定！！';
    end;
  3:     //抽检检查NG
    begin
      lbl_qty.Caption :=  '1/1';
      pnl_result.Caption := '抽检NG，设备锁定！！';
      uvLast_one := True;
      uvInput_count := 1;
    end;
  4:     //末件检查NG
    begin
      lbl_qty.Caption :=  '1/1';
      pnl_result.Caption := '末件NG，设备锁定！！';
      uvLast_one := True;
      uvInput_count := 1;
    end;
  end;
  dbg_inspect.Enabled := False;
  edt_fixture.Enabled := False;
  spb_save.Enabled := False;
  spb_close.Enabled := False;
end;

procedure Tfrm_Inspect.InspectionUnclock; //IPQC解锁
begin
  lbl_tag_qty.Font.Color := clBlack;
  lbl_qty.Font.Color := clBlack;
  pnl_result.Font.Color := clBlack;
  pnl_result.Color := clBtnFace;
  pnl_middle.Color := clBtnFace;
  case frm_main.rdg_unproductive.ItemIndex of
  -1..1:    //正常生产的产量算作正常生产
    begin

    end;
  2:     //首件解锁
    begin
      if uvLast_one then
        begin
          frm_main.rdg_unproductive.ItemIndex := -1;
          self.Close;
        end
      else
        begin
          with data_module.cds_inspect do
            begin
              if RecordCount>0 then
                begin
                  First;
                  while not Eof do
                    begin
                      Edit;
                      FieldByName('value').AsWideString := '';
                      FieldByName('note').AsWideString := '';
                      Post;
                      Next;
                    end;
                  First;
                end;
            end;
          edt_fixture.Text := '';
          pnl_result.Caption := '请填写检查参数';
          dbg_inspect.Enabled := True;
          edt_fixture.Enabled := True;
          spb_save.Enabled := True;
          spb_close.Enabled := True;
        end;
    end;
  3:     //抽检解锁
    begin
      frm_main.rdg_unproductive.ItemIndex := -1;
      self.Close;
    end;
  4:     //末件解锁
    begin
      frm_main.rdg_unproductive.ItemIndex := -1;
      self.Close;
    end;
  end;
end;

function InspectToJson(vDataset: TClientDataSet): String;
var
  i: Integer;
  keyValue:String;
begin
  keyValue:= '';
  try
    with vDataset do
      begin
        if (not Active) or (IsEmpty) then
          Result := '[]';
        Result := '[';
        if RecordCount>0 then
          begin
            First;
            while not vDataset.Eof do
              begin
                for i := 0 to FieldDefs.Count -1 do
                  begin
                    if (Fields[i].FieldName<>'name') and (Fields[i].FieldName<>'type') then
                      case Fields[i].DataType of
                        ftString : keyValue:= keyValue + Format('"%s":"%s",',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                        ftFloat : keyValue:= keyValue + Format('"%s":%s,',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                        ftInteger : keyValue:= keyValue + Format('"%s":%s,',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                        ftBoolean : keyValue:= keyValue + Format('"%s":%s,',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                      else
                        keyValue:= keyValue + Format('"%s":"%s",',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                      end;
                  end;
                keyValue:= Format('{%s}',[Copy(keyValue, 0, Length(keyValue)-1)]);
                if Result = '[' then
                  Result := Result + keyValue
                else
                  Result := Result + ',' + keyValue;
                keyValue := '';
                Next;
              end;
            Result := Result + ']';
          end;
      end;
  finally
    vDataset.EnableControls;
  end;
end;

procedure Tfrm_Inspect.dbg_inspectDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (Column.FieldName='name') or (Column.FieldName='type') or (Column.FieldName='code') then
    begin
      dbg_inspect.Canvas.Brush.color:=clInfoBk;//当前选中行的偶数列显示红色
    end;
 dbg_inspect.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure Tfrm_Inspect.dbg_inspectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key=VK_DOWN)or(Key=VK_TAB)) and (dbg_inspect.DataSource.DataSet.RecNo>=dbg_inspect.DataSource.DataSet.RecordCount) then
    key:=0;
end;

procedure Tfrm_Inspect.dbg_inspectKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
     begin
       keybd_event(vk_tab,0,0,0);
       keybd_event(vk_tab,0,keyeventf_keyup,0);
     end;
end;

procedure Tfrm_Inspect.FormKeyPress(Sender: TObject; var Key: Char);
const
  vInputLen = 6;
var
  vFinish: DWORD;
begin
  if uvIInput = '' then uvIStart := GetTickCount();
  if (Length(uvIInput) >= vInputLen) AND (Key=#13) then
    begin
      vFinish := GetTickCount();
      if (vFinish - uvIStart) / Length(uvIInput) < 100 then
        begin
          uvIInput := UpperCase(uvIInput);
          if copy(uvIInput,1,2)='AM' then  //扫描到的是职员
            begin
              if inspectionunlock(gvWorkorder_id, gvApp_id, uvIInput, '') then InspectionUnclock;
            end
          else
            begin
              log(DateTimeToStr(now())+', [ERROR] 扫描到非员工二维码【'+uvIInput+'】扫码解锁失败！');
            end;
        end
      else
        log(DateTimeToStr(now())+', [ERROR] 错误输入:' + uvIInput);
      uvIInput := '';
    end
  else
    begin
      uvIInput := uvIInput + Key;
    end;
end;

procedure Tfrm_Inspect.FormShow(Sender: TObject);
begin
  lbl_tag_qty.Font.Color := clBlack;
  lbl_qty.Font.Color := clBlack;
  pnl_result.Font.Color := clBlack;
  pnl_result.Color := clBtnFace;
  pnl_middle.Color := clBtnFace;
  case frm_main.rdg_unproductive.ItemIndex of
  -1..1:    //正常生产的产量算作正常生产
    begin

    end;
  2:     //首件的产量算作报废
    begin
      self.Caption := '安费诺宁德MES----首件检查';
      lbl_qty.Caption := '0/' + IntToStr(gvFirst_count);
    end;
  3:     //抽检的产量算作报废
    begin
      self.Caption := '安费诺宁德MES----抽检检查';
      lbl_qty.Caption := '0/1';
    end;
  4:     //末件的产量算作报废
    begin
      self.Caption := '安费诺宁德MES----末件检查';
      lbl_qty.Caption := '0/1';
    end;
  end;
  pnl_result.Caption := '请填写检查参数';
  dbg_inspect.Enabled := True;
  edt_fixture.Enabled := True;
  spb_save.Enabled := True;
  spb_close.Enabled := True;
end;

procedure Tfrm_Inspect.spb_saveClick(Sender: TObject);
var
  vParameters : WideString;
  vO: ISuperObject;
begin
  edt_fixture.SetFocus;
  uvIInput := '';
  with data_module.cds_inspect do
    begin
      if RecordCount>0 then
        begin
          First;
          while not Eof do
            begin
              if Trim(FieldByName('value').AsString)='' then
                begin
                  Application.MessageBox(PChar('参数名称【'+FieldByName('name').AsString+'】未填写数据！'),'错误',MB_ICONERROR);
                  Exit;
                end;
              Next;
            end;
        end
      else
        begin
          Application.MessageBox(PChar('首件检查记录没有设置，请联系管理员！'),'错误',MB_ICONERROR);
          Exit;
        end;
    end;
  vParameters := InspectToJson(data_module.cds_inspect);
  vO := SO(inspectionValue(vParameters, gvInspect_type, '', edt_fixture.Text));
  if vO.B['result.success'] then  //报检数据上传成功
    begin
      if vO.B['result.qualified'] then
        begin
          InspectionOK;
        end
      else
        begin
          InspectionNG;
        end;
    end
  else
    begin
      log(DateTimeToStr(now())+', [ERROR]提交检验数据失败，错误信息：'+vO.S['result.message']);
      Application.MessageBox(PChar('提交检验数据失败，错误信息：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
    end;
end;

procedure Tfrm_Inspect.spb_closeClick(Sender: TObject);
begin
  uvIInput := '';
  //设备信息保存
  if Application.MessageBox(PChar('确认完成了检测数据录入吗?'),'提示',MB_OKCANCEL)=IDOK then
    begin
      frm_main.rdg_unproductive.ItemIndex := -1;
      self.Close;
      uvInput_count := 1;
    end;
end;

end.
