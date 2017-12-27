unit frmMESLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.StdCtrls;

type
  Tfrm_MESLine = class(TForm)
    dlc_mesline: TDBLookupComboBox;
    dbg_station: TDBGrid;
    lbl_tag_line: TLabel;
    lbl_tag_station: TLabel;
    lbl_line: TLabel;
    lbl_station: TLabel;
    procedure FormShow(Sender: TObject);
    procedure dbg_stationDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dlc_meslineCloseUp(Sender: TObject);
    procedure dbg_stationDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_MESLine: Tfrm_MESLine;

implementation

uses frmMain, dataModule, publicLib, SuperObject;

{$R *.dfm}

procedure RefreshStation;
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
begin
  if frm_MESLine.dlc_mesline.KeyValue>0 then
    begin
      vO := SO('{"stationlist":' + data_module.cds_mesline.FieldByName('stationlist').AsString + '}');
      vA := vO.A['stationlist'];
      if vA.Length<>0 then   //ѡ������������й�λ��Ϣ
        begin
          with data_module.cds_station do
            begin
              EmptyDataSet;
              for i := 0 to vA.Length-1 do
                begin
                  Append;
                  vResult := SO(vA[i].AsString);
                  FieldByName('workstation_id').AsInteger := vResult.I['workstation_id'];
                  FieldByName('workstation_code').AsString := vResult.S['workstation_code'];
                  FieldByName('workstation_name').AsString := vResult.S['workstation_name'];
                  Post;
                end;
              First;
              while not eof do
                begin
                  if FieldByName('workstation_id').AsInteger=gvWorkstation_id then   //������Ϣ��������Ϣ����ͬ����ԭ��
                    begin
                      Break;
                    end;
                  Next;
                end;
            end;
        end
    end;
end;

procedure Tfrm_MESLine.dbg_stationDblClick(Sender: TObject);
var
  vMesline_id, vWorkstation_id : Integer;
begin
  if dbg_station.DataSource.DataSet.RecNo>0 then  //��λ��Ϣ���м�¼
    begin
      vMesline_id := frm_MESLine.dlc_mesline.KeyValue;
      vWorkstation_id := dbg_station.DataSource.DataSet.FieldByName('workstation_id').AsInteger;
      //ѡ��Ĳ��ߺ͹�λ�͵�ǰ���߹�λһ��
      if (vMesline_id=gvMESLine_id) and (vWorkstation_id=gvWorkstation_id) then
        begin
          Self.Hide;
        end
      else  //ѡ��Ĳ��ߺ͹�λ�͵�ǰ���߹�λ��һ��
        begin
          //�л����߳ɹ�
          if switchMESLine(vMesline_id, vWorkstation_id) then
            begin
              Self.Hide;
              RefreshEquipment;
              RefreshWorkorder;
              RefreshMaterials;
              RefreshStaff;
            end
          else  //�л�����ʧ��
            begin
              Self.Hide;
              frm_main.InfoTips('�������л�ʧ�ܣ�����ϵ����Ա��');
            end;
        end;
    end;
end;

procedure Tfrm_MESLine.dbg_stationDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if ((State = [gdSelected]) or (State=[gdSelected,gdFocused])) then
      begin
        dbg_station.Canvas.Font.Color :=ClYellow;
        dbg_station.Canvas.Brush.Color :=clblue;  //�ؼ�
        dbg_station.DefaultDrawColumnCell(Rect,DataCol,Column,State);
   end;
end;

procedure Tfrm_MESLine.dlc_meslineCloseUp(Sender: TObject);
begin
  RefreshStation;
end;

procedure Tfrm_MESLine.FormShow(Sender: TObject);
begin
  RefreshStation;
end;

end.
