unit frmFinish;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids, DBClient;

type
  Tfrm_finish = class(TForm)
    lbl_tag_doing_qty: TLabel;
    lbl_tag_good_qty: TLabel;
    lbl_tag_bad_qty: TLabel;
    lbl_bad_qty: TLabel;
    lbl_good_qty: TLabel;
    lbl_doing_qty: TLabel;
    lbl_tag_product_code: TLabel;
    lbl_product_code: TLabel;
    sbt_submit: TSpeedButton;
    dbg_badmode: TDBGrid;
    lbl_tag_container: TLabel;
    lbl_container: TLabel;
    edt_submit: TEdit;
    lbl_tag_submit: TLabel;
    procedure sbt_submitClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edt_submitChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function BadmodeToJson(vDataset: TClientDataSet): String;

var
  frm_finish: Tfrm_finish;
  uvInput : String;
  uvStart : DWORD;

implementation

uses frmMain, dataModule, publicLib, SuperObject;

{$R *.dfm}

function BadmodeToJson(vDataset: TClientDataSet): String;
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
        DisableControls;
        Filter := 'badmode_qty>' + '0';
        Filtered := True;
        if RecordCount>0 then
          begin
            First;
            while not vDataset.Eof do
              begin
                for i := 0 to FieldDefs.Count -1 do
                  begin
                    if Fields[i].FieldName<>'badmode_name' then
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
        Filtered := False;
      end;
  finally
    vDataset.EnableControls;
  end;
end;

procedure Tfrm_finish.edt_submitChange(Sender: TObject);
begin
  if edt_submit.Text='' then edt_submit.Text := '0';
  if StrToInt(edt_submit.Text)>gvDoing_qty then
    begin
      frm_finish.lbl_good_qty.Caption := '0';
      Application.MessageBox(PChar('报工数量不能大于待报工数量，请修改！'),'错误',MB_ICONERROR);
      edt_submit.SetFocus;
      edt_submit.SelectAll;
    end
  else
    begin
      frm_finish.lbl_good_qty.Caption := IntToStr(StrToInt(frm_finish.edt_submit.Text)-StrToInt(frm_finish.lbl_bad_qty.Caption));
    end;
end;

procedure Tfrm_finish.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then sbt_submit.Click;
end;

procedure Tfrm_finish.FormShow(Sender: TObject);
begin
  if edt_submit.Text='' then edt_submit.Text := '0';
  if gvLastworkcenter and (gvOutput_manner='container') then
    begin
      lbl_tag_container.Visible := True;
      lbl_container.Visible := True;
    end
  else
    begin
      lbl_tag_container.Visible := False;
      lbl_container.Visible := False;
    end;
end;

procedure Tfrm_finish.sbt_submitClick(Sender: TObject);
var
  vBadmode_lines, vS : String;
  vO: ISuperObject;
begin
  if frm_finish.lbl_bad_qty.Caption<>'0' then   //存在有不良模式,生产不良模式数组
    begin
      vBadmode_lines := BadmodeToJson(data_module.cds_badmode);
      log(vBadmode_lines);
    end
  else    //没有不良返回空数组
    begin
      vBadmode_lines := '[]';
    end;
  if gvline_type='flowing' then    //主线上
    begin
      log(DateTimeToStr(now())+', [INFO]开始调用报工方法');
      vO := SO(Virtual_FINISH(gvProduct_id, gvDoing_qty, vBadmode_lines));
      vS := vO.AsString;
      log(DateTimeToStr(now())+', [INFO]完成调用报工方法');
      if vO.B['result.success'] then  //报工成功
        begin
          frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+gvDoing_qty);
          frm_main.lbl_good_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_good_qty.Caption)+StrToInt(lbl_good_qty.Caption));
          frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+StrToInt(lbl_bad_qty.Caption));
          gvDoing_qty:=0;
          lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
          lbl_good_qty.Caption:=IntToStr(gvDoing_qty);
          lbl_bad_qty.Caption:=IntToStr(gvDoing_qty);
          frm_main.lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
          log(DateTimeToStr(now())+', [INFO]开始刷新工单');
          RefreshWorkorder;
          log(DateTimeToStr(now())+', [INFO]完成刷新工单');
          RefreshMaterials(gvConsumelist);
          log(DateTimeToStr(now())+', [INFO]完成刷新原材料');
          frm_finish.Hide;
        end
      else
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
           Application.MessageBox(PChar('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
        end;
    end
  else if gvline_type='station' then    //工作站
    begin
      if gvLastworkcenter and (gvOutput_manner='container') then
        begin
          vO := SO(workticket_FINISH(gvWorkticket_id, gvApp_id, StrToInt(edt_submit.Text), vBadmode_lines, gvContainer_id));
        end
      else
        begin
          vO := SO(workticket_FINISH(gvWorkticket_id, gvApp_id, StrToInt(edt_submit.Text), vBadmode_lines));
        end;
      if vO.B['result.success'] then  //报工成功
        begin
          gvDoing_qty:=gvDoing_qty-StrToInt(edt_submit.Text);
          frm_main.lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
          lbl_doing_qty.Caption:='0';
          edt_submit.Text:='0';
          lbl_good_qty.Caption:='0';
          lbl_bad_qty.Caption:='0';
          ini_set.WriteString('job', 'workorder', '');
          ini_set.WriteInteger('job', 'doing_qty', gvDoing_qty);
          ini_set.UpdateFile;
          RefreshWorkorder;
          RefreshMaterials;
          frm_finish.Hide;
        end
      else
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
          Application.MessageBox(PChar('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
        end;

    end;
end;

end.
