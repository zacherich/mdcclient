unit frmInspect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, DBClient, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  Tfrm_Inspect = class(TForm)
    dbg_inspect: TDBGrid;
    lbl_tag_wo: TLabel;
    lbl_tag_product_code: TLabel;
    lbl_wo: TLabel;
    lbl_product_code: TLabel;
    lbl_tag_input: TLabel;
    lbl_input: TLabel;
    spb_save: TSpeedButton;
    lbl_tag_fixture: TLabel;
    edt_fixture: TEdit;
    SpeedButton1: TSpeedButton;
    lbl_tag_result: TLabel;
    lbl_result: TLabel;
    procedure spb_saveClick(Sender: TObject);
    procedure dbg_inspectDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure dbg_inspectKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function InspectToJson(vDataset: TClientDataSet): String;

var
  frm_Inspect: Tfrm_Inspect;
  uvInput_count  : Integer = 1;
implementation

uses frmMain, dataModule, publicLib, SuperObject;

{$R *.dfm}

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

procedure Tfrm_Inspect.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
    if not (ActiveControl is TDbgrid) Then      //不是DBGrid组件
      begin
        key:=#0;
        SpeedButton1.Click;
      end
    else if (ActiveControl is TDbgrid) Then     //是Dbgrid组件
      begin
        key:=#9
      end;
end;

procedure Tfrm_Inspect.FormShow(Sender: TObject);
begin
  case frm_main.rdg_unproductive.ItemIndex of
  -1..1:    //正常生产的产量算作正常生产
    begin

    end;
  2:     //首件的产量算作报废
    begin
      self.Caption := '安费诺宁德MES----首件检查';
    end;
  3:     //抽检的产量算作报废
    begin
      self.Caption := '安费诺宁德MES----抽检检查';
    end;
  4:     //末件的产量算作报废
    begin
      self.Caption := '安费诺宁德MES----末件检查';
    end;
  end;
  lbl_result.Caption := '无';
  lbl_result.Font.Color := clWindowText;
end;

procedure Tfrm_Inspect.spb_saveClick(Sender: TObject);
var
  vParameters, vResult : WideString;
  vO: ISuperObject;
begin
  vParameters := InspectToJson(data_module.cds_inspect);
  vO := SO(inspectionValue(vParameters, gvInspect_type, '', edt_fixture.Text));
  if vO.B['result.success'] then  //报检数据上传成功
    begin
      if vO.B['result.qualified'] then
        begin
          vResult := 'OK';
          lbl_result.Caption := vResult;
          lbl_result.Font.Color := clGreen;
        end
      else
        begin
          vResult := 'NG';
          lbl_result.Caption := vResult;
          lbl_result.Font.Color := clRed;
        end;
      case frm_main.rdg_unproductive.ItemIndex of
      -1..1:    //正常生产的产量算作正常生产
        begin

        end;
      2:     //当前输入次数少于首件个数
        begin
          if uvInput_count<gvFirst_count then
            begin
              Application.MessageBox(PChar('已经录入'+IntToStr(uvInput_count)+'件首件信息，结果是：' + vResult + '。' + #13+'还要录入'+IntToStr(gvFirst_count-uvInput_count)+'件。'),'提示',MB_ICONINFORMATION);
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
              lbl_result.Caption := '无';
              lbl_result.Font.Color := clWindowText;
              edt_fixture.Text := '';
              Inc(uvInput_count);
            end
          else
            begin
              log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完成首件记录。');
              if Application.MessageBox(PChar('完成了检测数据录入，确认关闭吗?'),'提示',MB_OK)=IDOK then
                begin
                  frm_main.rdg_unproductive.ItemIndex := -1;
                  self.Hide;
                  uvInput_count := 1;
                end;
              uvInput_count := 1;
            end;
        end;
      3:     //当前输入次数少于抽检个数
        begin
          log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完抽检记录。');
          if Application.MessageBox(PChar('完成了检测数据录入，确认关闭吗?'),'提示',MB_OK)=IDOK then
            begin
              frm_main.rdg_unproductive.ItemIndex := -1;
              self.Hide;
              uvInput_count := 1;
            end;
          uvInput_count := 1;
        end;
      4:     //当前输入次数少于末件个数
        begin
          log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】成功完成末件记录。');
          if Application.MessageBox(PChar('完成了检测数据录入，确认关闭吗?'),'提示',MB_OK)=IDOK then
            begin
              frm_main.rdg_unproductive.ItemIndex := -1;
              self.Hide;
              uvInput_count := 1;
            end;
          uvInput_count := 1;
        end;
      end;
    end
  else
    begin
      log(DateTimeToStr(now())+', [ERROR]提交检验数据失败，错误信息：'+vO.S['result.message']);
      Application.MessageBox(PChar('提交检验数据失败，错误信息：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
    end;
end;

procedure Tfrm_Inspect.SpeedButton1Click(Sender: TObject);
begin
  //设备信息保存
  if Application.MessageBox(PChar('确认完成了检测数据录入吗?'),'提示',MB_OKCANCEL)=IDOK then
    begin
      frm_main.rdg_unproductive.ItemIndex := -1;
      self.Hide;
      uvInput_count := 1;
    end;
end;

end.
