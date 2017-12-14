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
    lbl_tag_container_code: TLabel;
    lbl_container_code: TLabel;
    lbl_tag_container_name: TLabel;
    lbl_container_name: TLabel;
    procedure sbt_submitClick(Sender: TObject);
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

procedure Tfrm_finish.sbt_submitClick(Sender: TObject);
var
  vBadmode_lines : String;
  vO: ISuperObject;
begin
  if lbl_bad_qty.Caption<>'0' then   //存在有不良模式,生产不良模式数组
    begin
      vBadmode_lines := BadmodeToJson(data_module.cds_badmode);
    end
  else    //没有不良返回空数组
    begin
      vBadmode_lines := '[]';
    end;
  if gvline_type='flowing' then    //主线上
    begin
      //
    end
  else if gvline_type='station' then    //工作站
    begin
      vO := SO(workticket_FINISH(gvWorkticket_id, gvApp_id, gvDoing_qty, vBadmode_lines, gvContainer_id));
      if vO.B['result.success'] then  //报工成功
        begin
          frm_main.lbl_doing_qty.Caption:='0';
          ini_set.WriteString('job', 'workorder', '');
          ini_set.WriteInteger('job', 'doing_qty', 0);
          ini_set.UpdateFile;
          gvDoing_qty:=0;
          frm_main.RefreshWorkorder;
          frm_main.RefreshMaterials;
          self.Hide;
        end
      else
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
          Application.MessageBox(PChar('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
        end;
    end;
end;

end.
