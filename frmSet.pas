unit frmSet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.FileCtrl,
  Vcl.Samples.Spin, Vcl.Buttons, Vcl.Grids, Redis.Client, Redis.Commons, Redis.Values, Redis.NetLib.Factory, Redis.NetLib.INDY;

type
  Tfrm_set = class(TForm)
    OpenDialog1: TOpenDialog;
    ButtonedEdit1: TButtonedEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Image1: TImage;
    lbl_tag_app_code: TLabel;
    lbl_tag_app_app_name: TLabel;
    lbl_tag_app_secret: TLabel;
    lbl_tag_line_code: TLabel;
    lbl_app_name: TLabel;
    lbl_line_code: TLabel;
    lbl_tag_station_code: TLabel;
    lbl_tag_station_name: TLabel;
    lbl_tag_state: TLabel;
    lbl_station_code: TLabel;
    lbl_station_name: TLabel;
    edt_app_secret: TEdit;
    TabSheet2: TTabSheet;
    lbl_tag_data_path: TLabel;
    lbl_data_path: TLabel;
    GroupBox1: TGroupBox;
    lbl_tag_template_file: TLabel;
    lbl_template_file: TLabel;
    lbl_tag_header_line: TLabel;
    lbl_tag_delimiter: TLabel;
    cmb_delimiter: TComboBox;
    spn_header_line: TSpinEdit;
    spb_load_file: TSpeedButton;
    cmb_datatype: TComboBox;
    stg_header_line_set: TStringGrid;
    spb_equipment_check: TSpeedButton;
    lbl_app_secret: TLabel;
    ckb_subfolder: TCheckBox;
    lbl_tag_monitor: TLabel;
    cmb_monitor: TComboBox;
    edt_app_code: TEdit;
    lbl_equipment_state: TLabel;
    lbl_app_id: TLabel;
    lbl_app_code: TLabel;
    lbl_station_id: TLabel;
    lbl_line_id: TLabel;
    rdg_filetype: TRadioGroup;
    lbl_tag_end_line: TLabel;
    lbl_tag_begin_line: TLabel;
    spn_end_line: TSpinEdit;
    spn_begin_line: TSpinEdit;
    lbl_tag_queue_name: TLabel;
    edt_queue_name: TEdit;
    btn_confirm: TBitBtn;
    btn_cancel: TBitBtn;
    lbl_tag_host: TLabel;
    lbl_tag_port: TLabel;
    lbl_host: TLabel;
    lbl_port: TLabel;
    ckb_testing: TCheckBox;
    lbl_tag_serialnumber: TLabel;
    lbl_tag_operation_pass: TLabel;
    lbl_tag_operate_result: TLabel;
    edt_test_sn_field: TEdit;
    edt_test_result_field: TEdit;
    edt_test_pass_value: TEdit;
    rdt_template: TRichEdit;
    procedure lbl_data_pathClick(Sender: TObject);
    procedure lbl_template_fileClick(Sender: TObject);
    procedure spn_header_lineChange(Sender: TObject);
    procedure cmb_delimiterChange(Sender: TObject);
    procedure spb_load_fileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmb_datatypeExit(Sender: TObject);
    procedure stg_header_line_setSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure spb_equipment_checkClick(Sender: TObject);
    procedure edt_app_codeChange(Sender: TObject);
    procedure rdg_filetypeClick(Sender: TObject);
    procedure spn_begin_lineChange(Sender: TObject);
    procedure spn_end_lineChange(Sender: TObject);
    procedure btn_confirmClick(Sender: TObject);
    procedure ckb_testingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  frm_set: Tfrm_set;

implementation

{$R *.dfm}

uses frmMain, publicLib, SuperObject, SuperXmlParser;

var
  uvCheckOK : Bool;

procedure Tfrm_set.btn_confirmClick(Sender: TObject);
var i : Integer;
    header_lines : String;
begin
  if uvCheckOk then
    begin
      if Trim(edt_queue_name.Text)='' then
        begin
          Application.MessageBox(PChar('Redis队列名称必须设置，请设置！'),'错误',MB_ICONERROR);
          TabSheet2.Show;
          edt_queue_name.SetFocus();
          edt_queue_name.SelectAll();
          Exit;
        end;
      case rdg_filetype.ItemIndex of
        0://普通文本文件
        begin
          if not DirectoryExists(lbl_data_path.Caption) then
            begin
              Application.MessageBox(PChar('采集文件路径设置错误，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          if not FileExists(lbl_template_file.Caption) then
            begin
              Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          if stg_header_line_set.RowCount-1<0 then
            begin
              Application.MessageBox(PChar('模板文件字段不存在，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          for i := 1 to stg_header_line_set.RowCount-1 do
            begin
              if stg_header_line_set.Cells[2,i]='' then
                begin
                  Application.MessageBox(PChar('标题别名不能为空，请重新设置！'),'错误',MB_ICONERROR);
                  TabSheet2.Show;
                  Exit;
                end;
              if stg_header_line_set.Cells[3,i]='' then
                begin
                  Application.MessageBox(PChar('标题类型不能为空，请重新设置！'),'错误',MB_ICONERROR);
                  TabSheet2.Show;
                  Exit;
                end;
            end;
          ini_set.EraseSection('collection');
          gvData_path := lbl_data_path.Caption;
          ini_set.WriteString('collection', 'data_path', gvData_path);
          gvSubfolder := ckb_subfolder.Checked;
          ini_set.WriteBool('collection', 'subfolder', gvSubfolder);
          gvFile_type := rdg_filetype.ItemIndex;
          ini_set.Writeinteger('collection', 'file_type', gvFile_type);
          gvMonitor_type := cmb_monitor.Text;
          ini_set.WriteString('collection', 'monitor_type', gvMonitor_type);
          gvTemplate_file := lbl_template_file.Caption;
          ini_set.WriteString('collection', 'template_file', gvTemplate_file);
          gvHeader_row := spn_header_line.Value;
          ini_set.Writeinteger('collection', 'header_row', gvHeader_row);
          gvDelimiter := cmb_delimiter.Text;
          ini_set.WriteString('collection', 'delimiter', gvDelimiter);
          case cmb_delimiter.ItemIndex of
            0 : gvDeli := #9;
            1 : gvDeli := ';';
            2 : gvDeli := ',';
          else
            gvDeli := ' ';
          end;
          for i := 1 to stg_header_line_set.RowCount-1 do
            begin
              if i=1 then
                header_lines:=stg_header_line_set.Cells[2,i]+'='+stg_header_line_set.Cells[3,i]
              else
                header_lines:=header_lines+gvDeli+stg_header_line_set.Cells[2,i]+'='+stg_header_line_set.Cells[3,i];
            end;
          gvHeader_lines := header_lines;
          ini_set.WriteString('collection', 'header_lines', gvHeader_lines);
          gvCol_count := stg_header_line_set.RowCount-1;
          ini_set.WriteInteger('collection', 'col_count', gvCol_count);
          ini_set.UpdateFile;
          //根据新的模板字段重构数据集
          CreateDataSet(gvHeader_lines, gvPrimary_key, gvDeli);
          //修改文件监控路径
          with frm_Main.OxygenDirectorySpy1 do begin
            Enabled := False;
            Directories.Clear;
            Directories.Add(gvData_path);
            Enabled := True;
          end;
          frm_Main.lbl_send_qty.Caption := '0';
          frm_Main.lbl_fail_qty.Caption := '0';
        end;
        1://扭矩焊文件
        begin
          if not DirectoryExists(lbl_data_path.Caption) then
            begin
              Application.MessageBox(PChar('采集文件路径设置错误，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          if not FileExists(lbl_template_file.Caption) then
            begin
              Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          if stg_header_line_set.RowCount-1<0 then
            begin
              Application.MessageBox(PChar('模板文件字段不存在，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          for i := 1 to stg_header_line_set.RowCount-1 do
            begin
              if stg_header_line_set.Cells[2,i]='' then
                begin
                  Application.MessageBox(PChar('标题别名不能为空，请重新设置！'),'错误',MB_ICONERROR);
                  TabSheet2.Show;
                  Exit;
                end;
              if stg_header_line_set.Cells[3,i]='' then
                begin
                  Application.MessageBox(PChar('标题类型不能为空，请重新设置！'),'错误',MB_ICONERROR);
                  TabSheet2.Show;
                  Exit;
                end;
            end;
          ini_set.EraseSection('collection');
          gvData_path := lbl_data_path.Caption;
          ini_set.WriteString('collection', 'data_path', gvData_path);
          gvSubfolder := ckb_subfolder.Checked;
          ini_set.WriteBool('collection', 'subfolder', gvSubfolder);
          gvFile_type := rdg_filetype.ItemIndex;
          ini_set.Writeinteger('collection', 'file_type', gvFile_type);
          gvMonitor_type := cmb_monitor.Text;
          ini_set.WriteString('collection', 'monitor_type', gvMonitor_type);
          gvTemplate_file := lbl_template_file.Caption;
          ini_set.WriteString('collection', 'template_file', gvTemplate_file);
          gvBegin_row := spn_begin_line.Value;
          ini_set.Writeinteger('collection', 'begin_row', gvBegin_row);
          gvEnd_row := spn_end_line.Value;
          ini_set.Writeinteger('collection', 'end_row', gvEnd_row);
          gvDelimiter := cmb_delimiter.Text;
          ini_set.WriteString('collection', 'delimiter', gvDelimiter);
         case cmb_delimiter.ItemIndex of
            0 : gvDeli := #9;
            1 : gvDeli := ';';
            2 : gvDeli := ',';
          else
            gvDeli := ' ';
          end;
          for i := 1 to stg_header_line_set.RowCount-1 do
            begin
              if i=1 then
                header_lines:=stg_header_line_set.Cells[2,i]+'='+stg_header_line_set.Cells[3,i]
              else
                header_lines:=header_lines+gvDeli+stg_header_line_set.Cells[2,i]+'='+stg_header_line_set.Cells[3,i];
            end;
          gvHeader_lines := header_lines;
          ini_set.WriteString('collection', 'header_lines', gvHeader_lines);
          gvCol_count := stg_header_line_set.RowCount-1;
          ini_set.WriteInteger('collection', 'col_count', gvCol_count);
          ini_set.UpdateFile;
          //根据新的模板字段重构数据集
          CreateDataSet(gvHeader_lines, gvPrimary_key, gvDeli);
          //修改文件监控路径
          with frm_Main.OxygenDirectorySpy1 do begin
            Enabled := False;
            Directories.Clear;
            Directories.Add(gvData_path);
            Enabled := True;
          end;
          frm_Main.lbl_send_qty.Caption := '0';
          frm_Main.lbl_fail_qty.Caption := '0';
        end;
        2://极柱焊文件
        begin
          if not DirectoryExists(lbl_data_path.Caption) then
            begin
              Application.MessageBox(PChar('采集文件路径设置错误，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          if not FileExists(lbl_template_file.Caption) then
            begin
              Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          if stg_header_line_set.RowCount-1<0 then
            begin
              Application.MessageBox(PChar('模板文件字段不存在，请重新设置！'),'错误',MB_ICONERROR);
              TabSheet2.Show;
              Exit;
            end;
          for i := 1 to stg_header_line_set.RowCount-1 do
            begin
              if stg_header_line_set.Cells[2,i]='' then
                begin
                  Application.MessageBox(PChar('标题名称不能为空，请重新设置！'),'错误',MB_ICONERROR);
                  TabSheet2.Show;
                  Exit;
                end;
              if stg_header_line_set.Cells[3,i]='' then
                begin
                  Application.MessageBox(PChar('标题类型不能为空，请重新设置！'),'错误',MB_ICONERROR);
                  TabSheet2.Show;
                  Exit;
                end;
            end;
          ini_set.EraseSection('collection');
          gvData_path := lbl_data_path.Caption;
          ini_set.WriteString('collection', 'data_path', gvData_path);
          gvSubfolder := ckb_subfolder.Checked;
          ini_set.WriteBool('collection', 'subfolder', gvSubfolder);
          gvFile_type := rdg_filetype.ItemIndex;
          ini_set.Writeinteger('collection', 'file_type', gvFile_type);
          gvMonitor_type := cmb_monitor.Text;
          ini_set.WriteString('collection', 'monitor_type', gvMonitor_type);
          gvTemplate_file := lbl_template_file.Caption;
          ini_set.WriteString('collection', 'template_file', gvTemplate_file);
          gvBegin_row := spn_begin_line.Value;
          ini_set.Writeinteger('collection', 'begin_row', gvBegin_row);
          gvEnd_row := spn_end_line.Value;
          ini_set.Writeinteger('collection', 'end_row', gvEnd_row);
          gvDelimiter := cmb_delimiter.Text;
          ini_set.WriteString('collection', 'delimiter', gvDelimiter);
         case cmb_delimiter.ItemIndex of
            0 : gvDeli := #9;
            1 : gvDeli := ';';
            2 : gvDeli := ',';
          else
            gvDeli := ' ';
          end;
          for i := 1 to stg_header_line_set.RowCount-1 do
            begin
              if i=1 then
                header_lines:=stg_header_line_set.Cells[2,i]+'='+stg_header_line_set.Cells[3,i]
              else
                header_lines:=header_lines+gvDeli+stg_header_line_set.Cells[2,i]+'='+stg_header_line_set.Cells[3,i];
            end;
          gvHeader_lines := header_lines;
          ini_set.WriteString('collection', 'header_lines', gvHeader_lines);
          gvCol_count := stg_header_line_set.RowCount-1;
          ini_set.WriteInteger('collection', 'col_count', gvCol_count);
          ini_set.UpdateFile;
          //根据新的模板字段重构数据集
          CreateDataSet(gvHeader_lines, gvPrimary_key, gvDeli);
          //修改文件监控路径
          with frm_Main.OxygenDirectorySpy1 do begin
            Enabled := False;
            Directories.Clear;
            Directories.Add(gvData_path);
            Enabled := True;
          end;
          frm_Main.lbl_send_qty.Caption := '0';
          frm_Main.lbl_fail_qty.Caption := '0';
        end;
      end;

    //设备信息保存
    ini_set.EraseSection('equipment');
    gvApp_id := StrToInt(lbl_app_id.Caption);
    gvApp_code := Trim(edt_app_code.Text);
    ini_set.WriteString('equipment', 'app_code', gvApp_code);
    gvApp_name := lbl_app_name.Caption;
    if Length(Trim(edt_app_secret.Text))=0 then
      gvApp_secret := 0
    else
      gvApp_secret := StrToInt(Trim(edt_app_secret.Text));
    ini_set.WriteInteger('equipment', 'app_secret', gvApp_secret);

    gvApp_testing := ckb_testing.Checked;
    ini_set.WriteBool('equipment', 'app_testing', gvApp_testing);
    gvTest_SN_field := Trim(edt_test_sn_field.Text);
    ini_set.WriteString('equipment', 'test_sn_field', gvTest_SN_field);
    gvTest_result_field := Trim(edt_test_result_field.Text);
    ini_set.WriteString('equipment', 'test_result_field', gvTest_result_field);
    gvTest_pass_value := Trim(edt_test_pass_value.Text);
    ini_set.WriteString('equipment', 'test_pass_value', gvTest_pass_value);
    ini_set.UpdateFile;
    //设备信息保存
    if Application.MessageBox(PChar('设备信息、数据采集配置成功,是否保存?'),'提示',MB_OKCANCEL)=IDOK then
      begin
        Self.ModalResult := mrOk;
      end;
    end
  else
    begin
      Application.MessageBox(PChar('设备信息需要验证，请先做验证！'),'错误',MB_ICONERROR);
      TabSheet1.Show;
      edt_app_code.SetFocus();
      edt_app_code.SelectAll();
    end;
end;

procedure Tfrm_set.ckb_testingClick(Sender: TObject);
begin
  lbl_tag_serialnumber.Visible := ckb_testing.Checked;
  lbl_tag_operation_pass.Visible := ckb_testing.Checked;
  lbl_tag_operate_result.Visible := ckb_testing.Checked;
  edt_test_sn_field.Visible := ckb_testing.Checked;
  edt_test_result_field.Visible := ckb_testing.Checked;
  edt_test_pass_value.Visible := ckb_testing.Checked;
end;

procedure Tfrm_set.cmb_datatypeExit(Sender: TObject);
begin
  with Sender as TComboBox do
    begin
      hide;
      if itemindex >= 0 then
        with stg_header_line_set do
          Cells[col, row] := Items[itemindex];
    end;
end;

procedure Tfrm_set.cmb_delimiterChange(Sender: TObject);
begin
  if not FileExists(lbl_template_file.Caption) then
    begin
      Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
      Exit;
    end;
end;

procedure Tfrm_set.edt_app_codeChange(Sender: TObject);
begin
  uvCheckOK := False;
end;

procedure Tfrm_set.FormCreate(Sender: TObject);
begin
  cmb_datatype.Visible := False;
end;

procedure Tfrm_set.FormShow(Sender: TObject);
var vList : TStringList;
    vFile : TFileStream;
begin
  //显示设备信息
  ckb_testing.Checked := gvApp_testing;
  edt_test_sn_field.Text := gvTest_SN_field;
  edt_test_result_field.Text := gvTest_result_field;
  edt_test_pass_value.Text := gvTest_pass_value;

  //读取设备采集配置信息
  lbl_data_path.Caption := gvData_path;
  ckb_subfolder.Checked := gvSubfolder;
  cmb_delimiter.ItemIndex := cmb_delimiter.Items.IndexOf(Trim(gvDelimiter));
  rdg_filetype.ItemIndex := gvFile_type;
  rdg_filetype.OnClick(Sender);
  cmb_monitor.ItemIndex:=cmb_monitor.Items.IndexOf(Trim(gvMonitor_type));
  lbl_template_file.Caption := gvTemplate_file;
  if FileExists(lbl_template_file.Caption) then
    begin
      rdt_template.Lines.Clear;
      vList := TStringList.Create;
      try
        vFile := TFileStream.Create(lbl_template_file.Caption, fmOpenRead);
        vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
        case rdg_filetype.ItemIndex of
          0://普通文本文件
          begin
            //if (vList.Count>0) and (vList.Count<100) then
              rdt_template.Lines.Text:=vList.Text;
            //else
            //  begin
            //    for i := 0 to 10 do
            //      begin
            //        rdt_template.Lines.Add(vList[i]);
            //      end;
            //  end;
            spn_header_line.MinValue:=1;
            spn_header_line.MaxValue:=rdt_template.Lines.Count;
          end;
          1://扭矩焊文件
          begin
            if vList.Count>0 then
              begin
                rdt_template.Lines.Text := vList.Text;
                spn_begin_line.MinValue:=1;
                spn_begin_line.MaxValue:=rdt_template.Lines.Count;
                spn_end_line.MinValue:=1;
                spn_end_line.MaxValue:=rdt_template.Lines.Count;
              end;
          end;
          2://极柱焊文件
          begin
            if vList.Count>0 then
              begin
                rdt_template.Lines.Text := vList.Text;
                spn_begin_line.MinValue:=1;
                spn_begin_line.MaxValue:=rdt_template.Lines.Count;
                spn_end_line.MinValue:=1;
                spn_end_line.MaxValue:=rdt_template.Lines.Count;
              end;
          end;
        end;
      finally
        vFile.Destroy;
        vList.Destroy;
      end;
    end;
  ckb_testingClick(Self);  //显示测试机字段
end;

procedure Tfrm_set.lbl_data_pathClick(Sender: TObject);
var vDir : String;
begin
  if not SelectDirectory('选择需要监控的文件夹:', '', vDir) then Exit;
  lbl_data_path.Caption:=vDir;
end;

procedure Tfrm_set.lbl_template_fileClick(Sender: TObject);
var vList : TStringList;
    vFile : TFileStream;
begin
  with OpenDialog1 do
    begin
      if DirectoryExists(lbl_data_path.Caption) then InitialDir:=lbl_data_path.Caption;
      Filter:= '文本文件（*.csv;*.tsv;*.twd）|*.csv;*.tsv;*.twd';
      FilterIndex:=1;
      Execute;
    end;
  if OpenDialog1.FileName<>'' then
    begin
      lbl_template_file.Caption:=OpenDialog1.FileName;
      rdt_template.Lines.Clear;
      vList := TStringList.Create ;
      try
        vFile := TFileStream.Create(lbl_template_file.Caption, fmOpenRead);
        vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
        case rdg_filetype.ItemIndex of
          0://普通文本文件
          begin
            //if (vList.Count>0) and (vList.Count<100) then
            rdt_template.Lines.Text:=vList.Text;
            //else
            //  begin
            //    for i := 0 to 10 do
            //      begin
            //        rdt_template.Lines.Add(vList[i]);
            //      end;
            //  end;
            spn_header_line.MinValue:=1;
            spn_header_line.MaxValue:=rdt_template.Lines.Count;
          end;
          1://扭矩焊文件
          begin
            if vList.Count>0 then
              begin
                rdt_template.Lines.Text := vList.Text;
                spn_begin_line.MinValue:=1;
                spn_begin_line.MaxValue:=rdt_template.Lines.Count;
                spn_end_line.MinValue:=1;
                spn_end_line.MaxValue:=rdt_template.Lines.Count;
              end;
          end;
          2://极柱焊文件
          begin
            if vList.Count>0 then
              begin
                rdt_template.Lines.Text := vList.Text;
                spn_begin_line.MinValue:=1;
                spn_begin_line.MaxValue:=rdt_template.Lines.Count;
                spn_end_line.MinValue:=1;
                spn_end_line.MaxValue:=rdt_template.Lines.Count;
              end;
          end;
        end;
      finally
        vList.Destroy;
      end;
    end;
end;

procedure Tfrm_set.rdg_filetypeClick(Sender: TObject);
begin
  case rdg_filetype.ItemIndex of
    0://普通文本文件
    begin
      lbl_tag_header_line.Visible := True;
      spn_header_line.Visible := True;
      lbl_tag_begin_line.Visible := False;
      spn_begin_line.Visible := False;
      lbl_tag_end_line.Visible := False;
      spn_end_line.Visible := False;
    end;
    1://扭矩焊文件
    begin
      lbl_tag_header_line.Visible := False;
      spn_header_line.Visible := False;
      lbl_tag_begin_line.Visible := True;
      spn_begin_line.Visible := True;
      lbl_tag_end_line.Visible := True;
      spn_end_line.Visible := True;
    end;
    2://极柱焊文件
    begin
      lbl_tag_header_line.Visible := False;
      spn_header_line.Visible := False;
      lbl_tag_begin_line.Visible := True;
      spn_begin_line.Visible := True;
      lbl_tag_end_line.Visible := True;
      spn_end_line.Visible := True;
    end;
  end;
end;

procedure Tfrm_set.spb_load_fileClick(Sender: TObject);
var
  vList : TStringList;
  vO: ISuperObject;
  vItem: TSuperAvlEntry;
  i : integer;
begin
  if not DirectoryExists(lbl_data_path.Caption) then
    begin
      Application.MessageBox(PChar('采集文件路径设置错误，请重新设置！'),'错误',MB_ICONERROR);
      Exit;
    end;
  if not FileExists(lbl_template_file.Caption) then
    begin
      Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
      Exit;
    end;
  vList := TStringList.Create;
  case rdg_filetype.ItemIndex of
    0://普通文本文件
    begin
      try
        vList.StrictDelimiter := True;
        case cmb_delimiter.ItemIndex of
          0 : vList.Delimiter := #9;
          1 : vList.Delimiter := ';';
          2 : vList.Delimiter := ',';
        else
          vList.Delimiter := ' ';
        end;
        if spn_header_line.Value>0 then
          vList.DelimitedText := rdt_template.Lines[spn_header_line.Value-1];
        if vList.Count>0 then
          begin
            //设置stg_header_line_set基本属性
            stg_header_line_set.RowCount:=vList.Count+1;
            stg_header_line_set.ColWidths[0]:=50;
            stg_header_line_set.Cells[0,0]:='序号';
            stg_header_line_set.Cells[1,0]:='原标题名';
            stg_header_line_set.Cells[2,0]:='标题别名';
            stg_header_line_set.Cells[3,0]:='数据类型';
            stg_header_line_set.Cells[4,0]:='数据长度';
            stg_header_line_set.Cells[5,0]:='小数位数';
            stg_header_line_set.Cells[6,0]:='主键';
            for i:=1 to vList.Count do
              begin
                stg_header_line_set.Cells[0,i]:=inttostr(i);
                stg_header_line_set.Cells[1,i]:=vList[i-1];
                stg_header_line_set.Cells[2,i]:=vList[i-1];
              end;
          end;
      finally
        vList.Free;
      end;
    end;
    1://扭矩焊文件
    begin
      try
        if (spn_end_line.Value>=spn_begin_line.Value) and (spn_begin_line.Value>0) then
          begin
            for i := spn_begin_line.Value-1 to spn_end_line.Value-1 do
              begin
                vList.Add(rdt_template.Lines[i]);
              end;
            if vList.Text<>'' then vO := XMLParseString(vList.Text,true) else Exit;
            if vO.asObject.Count>0 then
              begin
                //设置stg_header_line_set基本属性
                stg_header_line_set.RowCount:=vO.asObject.Count+1;
                stg_header_line_set.ColWidths[0]:=50;
                stg_header_line_set.Cells[0,0]:='序号';
                stg_header_line_set.Cells[1,0]:='原标题名';
                stg_header_line_set.Cells[2,0]:='标题别名';
                stg_header_line_set.Cells[3,0]:='数据类型';
                stg_header_line_set.Cells[4,0]:='数据长度';
                stg_header_line_set.Cells[5,0]:='小数位数';
                stg_header_line_set.Cells[6,0]:='主键';
                i := 1;
                for vItem in vO.AsObject do
                  begin
                    stg_header_line_set.Cells[0,i]:=inttostr(i);
                    stg_header_line_set.Cells[1,i]:=vItem.Name;
                    stg_header_line_set.Cells[2,i]:=vItem.Name;
                    i := i+1;
                  end;
              end;
          end;
      finally
        vList.Free;
      end;
    end;
    2://极柱焊文件
    begin
      try
        if (spn_end_line.Value>=spn_begin_line.Value) and (spn_begin_line.Value>0) then
          begin
            for i := spn_begin_line.Value-1 to spn_end_line.Value-1 do
              begin
                vList.Add(rdt_template.Lines[i]);
              end;
            if vList.Count>0 then
              begin
                //设置stg_header_line_set基本属性
                stg_header_line_set.RowCount:=vList.Count+1;
                stg_header_line_set.ColWidths[0]:=50;
                stg_header_line_set.Cells[0,0]:='序号';
                stg_header_line_set.Cells[1,0]:='采样数据';
                stg_header_line_set.Cells[2,0]:='标题名称';
                stg_header_line_set.Cells[3,0]:='数据类型';
                stg_header_line_set.Cells[4,0]:='数据长度';
                stg_header_line_set.Cells[5,0]:='小数位数';
                stg_header_line_set.Cells[6,0]:='主键';
                for i:=1 to vList.Count do
                  begin
                    stg_header_line_set.Cells[0,i]:=inttostr(i);
                    stg_header_line_set.Cells[1,i]:=vList[i-1];
                  end;
              end;
          end;
      finally
        vList.Free;
      end;
    end;
  end;
end;

procedure Tfrm_set.spb_equipment_checkClick(Sender: TObject);
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
begin
  //测试机必填字段检查
  if ckb_testing.Checked then
    begin
      if Trim(edt_test_sn_field.Text)='' then
        begin
          MessageBox(self.Handle, '测试机数据中的序列号字段必填，请输入!', '错误', MB_OK + MB_ICONERROR);
          Exit;
        end;
      if Trim(edt_test_result_field.Text)='' then
        begin
          MessageBox(self.Handle, '测试机数据中的测试结果字段必填，请输入!', '错误', MB_OK + MB_ICONERROR);
          Exit;
        end;
      if Trim(edt_test_pass_value.Text)='' then
        begin
          MessageBox(self.Handle, '测试机数据中的测试成功值必填，请输入!', '错误', MB_OK + MB_ICONERROR);
          Exit;
        end;
    end;
  //设备信息检查
  if Trim(edt_app_code.Text)='' then
    begin
      MessageBox(self.Handle, '设备编码必填，请输入!', '错误', MB_OK + MB_ICONERROR);
      edt_app_code.SetFocus();
      edt_app_code.SelectAll();
    end
  else
    begin
      vO := SO(JsonRPCsearch_read(Aurl(gvServer_Host,gvServer_Port), gvDatabase, gvUserID, gvPassword, 'aas.equipment.equipment', '[["code","=","'+Trim(edt_app_code.Text)+'"]]', '["id","code","name","active","mesline_id","workstation_id","state"]'));
      vA := vO['result'].AsArray;
      if vA.Length=0 then
        begin
          MessageBox(self.Handle, '设备编码不存在，请重新输入!', '错误', MB_OK + MB_ICONERROR);
        end
      else
        begin
          vResult := SO(vA[0].AsString);
          lbl_app_id.Caption:= IntToStr(vResult.I['id']);
          //gvApp_code := vResult.S['code'];
          lbl_app_name.Caption := vResult.S['name'];
          lbl_equipment_state.Caption:= vResult.S['state'];
          vA := vResult['mesline_id'].AsArray;
          lbl_line_id.Caption := IntToStr(vA[0].AsInteger);
          lbl_line_code.Caption := vA[1].AsString;
          vA := vResult['workstation_id'].AsArray;
          lbl_station_id.Caption := IntToStr(vA[0].AsInteger);
          lbl_station_code.Caption := GetCodeName('[', ']', vA[1].AsString,0);
          lbl_station_name.Caption := GetCodeName('[', ']', vA[1].AsString,1);
          uvCheckOK := True;
        end;
    end;
end;

procedure Tfrm_set.spn_begin_lineChange(Sender: TObject);
begin
  if not FileExists(lbl_template_file.Caption) then
    begin
      Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
      Exit;
    end;
  if spn_begin_line.Value>rdt_template.Lines.Count then
    Application.MessageBox(PChar('超出模板文件行数，请重新设置！'),'错误',MB_ICONERROR)
  else
    begin
//      uvBeginRow := spn_begin_line.Value;  //指定模板文件行数
//      sdt_template.Repaint;   //模板文件行数高亮显示
    end;
end;

procedure Tfrm_set.spn_end_lineChange(Sender: TObject);
begin
  if not FileExists(lbl_template_file.Caption) then
    begin
      Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
      Exit;
    end;
  if spn_begin_line.Value>rdt_template.Lines.Count then
    Application.MessageBox(PChar('超出模板文件行数，请重新设置！'),'错误',MB_ICONERROR)
  else
    begin
//      uvEndRow := spn_end_line.Value;  //指定模板文件行数
//      sdt_template.Repaint;   //模板文件行数高亮显示
    end;
end;

procedure Tfrm_set.spn_header_lineChange(Sender: TObject);
begin
  if not FileExists(lbl_template_file.Caption) then
    begin
      Application.MessageBox(PChar('模板文件不存在，请重新设置！'),'错误',MB_ICONERROR);
      Exit;
    end;
  if spn_header_line.Value>rdt_template.Lines.Count then
    Application.MessageBox(PChar('超出模板文件行数，请重新设置！'),'错误',MB_ICONERROR)
  else
    begin
//      uvBlueLine := spn_header_line.Value;  //指定模板文件行数
//      sdt_template.Repaint;   //模板文件行数高亮显示
    end;
end;

procedure Tfrm_set.stg_header_line_setSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  R: TRect;
  org: TPoint;
begin
  with Sender as TStringGrid do
    begin
      if ACol = 1 then
        Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      else
        Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor];

      if (ACol = 3) and (ARow >= FixedRows) then //在第二列显示一个ComboBox
      begin
        perform(WM_CANCELMODE, 0, 0);
        R := CellRect(ACol, ARow);
        org := Self.ScreenToClient(ClientToScreen(R.topleft));
        with cmb_datatype do
        begin
          setbounds(org.X, org.Y, R.right - R.left, height);
          itemindex := Items.IndexOf(Cells[ACol, ARow]);
          Show;
          BringTofront;
          SetFocus;
          DroppedDown := true;
        end;
      end;
    end;
end;

end.
