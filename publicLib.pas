unit publicLib;

interface
uses
  Winapi.Windows, System.SysUtils, System.StrUtils, System.Classes, System.IniFiles, Vcl.Graphics,
  DB, DBClient, WinSock, IdHTTP, IdSSLOpenSSL, superobject;

  function ToUTF8Encode(str: string): string;
  function EncodeUniCode(Str:WideString):string;
  procedure WorkorderInfoCDS;
  procedure MaterialsInfoCDS;
  procedure BadmodeCDS;
  procedure MESLineCDS;
  procedure StationCDS;
  Procedure DataCollectionCDS(const fHeadlines, fPrimary_key: string; const fDeli: Char);
  function GetFileType(FileName:String):string;
  function GetLastLine(fName : String) : String;
  //取基础资料编码或名称的函数，形如导线整形[SP_000]
  function GetCodeName(fvStart,fvEnd,fvInputStr:string;fvTag:Shortint):string;
  //根据某个字符分割字符串的函数
  procedure SplitStr(s : string; fSplit : char; fQty : Integer; fTerms : TStringList);
  //ClientDataset转1条JSON
  function CDS1LineToJson(srcCDS: TClientDataSet): String;
  //MDC接口协议JSON
  function MDCEncode(const fApp_code, fApp_secret, fOperate_time, fData_type, fStation_code, fStaff_code, fStaff_name,
                     fProduct_code, fLot_code, fSerial_number, fMaterial_info, fJob_id, fJob_code, fWorkorder_id, fWorkorder_code: String; fData : String) : String;
  //按照固定字符串长度拆分，用于短信内容拆分
  function WrapWideString(mText:WideString; mLength : Integer): String;
  Procedure NewTxt(filePath:String);
  Procedure AppendTxt(filePath:String;Str:String);
  Procedure Log(Str:String; Color: TColor = clBlack);
  function Aurl(CONST fvHost: String; CONST fvPort: Integer): String;
  //JSONRPC封装函数——调用RPC
  function JsonRPCCall(fvURL: String; CONST fvParams: String): String;
  //JSONRPC封装函数——列出数据库
  function JsonRPCdblist(fvURL: String): String;
  function JsonRPClogin(fvURL: String; CONST fvDB: String; CONST fvUsername: String; CONST fvPassword: String): String;
  function JsonRPCobject(fvURL: String; CONST fvArgs: String): String;
  function JsonRPCsearch_read(fvURL: String; CONST fvDB: String; CONST fvUserid: Integer; CONST fvPassword: String;
                              CONST fvModel: String; CONST fvDomain: String; CONST fvFields: String  ): String;
  function scanStaff(CONST fvBarcode: String): String;   //扫码考勤
  function queryEquipment : Bool;    //查询设备信息
  function queryStaffExist : Bool;    //查询员工是否在岗
  function queryLineType(CONST fvLine_code: String): Bool;   //查询生产线类型
  function switchMESLine(CONST fvMesline_id, fvWorkstation_id: Integer): Bool;   //切换生产线和工位
  function queryRedis(CONST fvQueue_name: String): Bool;   //查询redis信息
  function scanWorkticket(CONST fvBarcode: String): String;   //扫描工票工单
  function scanContainer(CONST fvBarcode: String): String;   //扫描容器
  function getLineWorkorder : String;  //查询主线工单
  function feedMaterial(CONST fvBarcode: String): String;   //设备上料
  function getFeedMaterials : String;     //查询设备上料信息
  function getWorkordConsume(CONST fvWorkorder_id, fvWorkcenter_id: Integer): String;  //查询工单上工位的消耗信息
  function queryBadmode : String;
  function queryMESLine : String;
  function workticket_START(CONST fvWorkticket_id, fvApp_id: Integer): String;
  function workticket_FINISH(CONST fvWorkticket_id, fvApp_id: Integer; CONST fvCommit_qty : Currency; CONST fvBadmode_lines: String; CONST fvContainer_id: Integer): String;   //工票工单完工
  function Virtual_FINISH(CONST  fvProduct_id: Integer; CONST fvOutput_qty : Currency): String;   //子工单虚拟建完工
  function testingRecord(CONST fvSerialnumber : String; CONST fvOperation_pass : Bool; CONST fvOperate_result: String): Bool;   //保存测试数据
var
  ini_set : TMemIniFile;
  //mdc首层接口JSON
  gvApp_id : Integer;
  gvApp_code : String;
  gvApp_name : String;
  gvApp_testing : Bool;
  gvTest_operator_field : String;
  gvTest_SN_field : String;
  gvTest_result_field : String;
  gvTest_pass_value : String;

  gvApp_state : String;
  gvApp_secret : Integer;
  gvData_type : String;
  gvMESLine_id : Integer;
  gvMESLine_name : String;
  gvline_type : String;
  gvWorkday_start : String;
  gvSchedule_id : Integer;
  gvWorkstation_id : Integer;
  gvWorkstation_code : String;
  gvWorkstation_name : String;
  gvStaff_id : Integer;
  gvStaff_code : String;
  gvStaff_name : String;
  ////mdc内层接口JSON
  gvData_path : String;
  gvSubfolder : Bool;
  gvTemplate_file : String;
  gvHeader_row : integer;
  gvBegin_row : integer;
  gvEnd_row : integer;
  gvDelimiter : String;
  gvdeli : Char;
  gvHeader_lines : String;
  gvHeader_list : TStringList;
  gvFile_type : Shortint;
  gvMonitor_type : String;
  gvPrimary_key : String;
  gvCol_count : Integer;
  //Redis网络设置
  gvQueue_name : String;
  gvRedis_Host : String;
  gvRedis_Port : Integer;
  gvUse_Proxy : Bool;
  //odoo网络设置
  gvServer_Host : String;
  gvServer_Port : Integer;
  gvDatabase : String;
  gvSave_PWD : Bool;
  gvUserID : Integer;
  gvUserName : String;
  gvPassword : String;
  //在制工单
  gvMainorder_id : Integer;
  gvMainorder_name : String;
  gvWorkorder_barcode : String;
  gvWorkorder_id : Integer;
  gvWorkorder_name : String;
  gvWorkticket_id : Integer;
  gvWorkticket_name : String;
  gvWorkcenter_id : Integer;
  gvWorkcenter_name : String;
  gvWorkticket_state : String;
  gvContainer_id : Integer;
  gvContainer_code : String;
  gvContainer_name : String;
  gvProduct_id : Integer;
  gvProduct_code : String;
  gvLastworkcenter : Bool;
  gvSequence : Integer;
  gvInput_qty : Currency;
  gvOutput_qty : Currency;
  gvBadmode_qty : Currency;
  gvWeld_count : Integer;
  gvDoing_qty : Integer;
  gvConsumelist : String;
  //统计变量
  gvWorkorder_rowno : Integer;
  gvSucceed : Integer;
  gvFail : Integer;

implementation

uses
  dataModule, frmMain, frmFinish, frmMESLine;

function EncodeUniCode(Str:WideString):string; //字符串－>PDU
var
   i,len:Integer;
   cur:Integer;
begin
   Result:='';
   len:=Length(Str);
   i:=1;
   while i<=len do
   begin
      cur:=ord(Str[i]);
      Result:=Result+'\u'+IntToHex(Cur,4);
      inc(i);
   end;
end;

function ToUTF8Encode(str: string): string;  //将字符串编码为UTF8
var
  b: Byte;
begin
  for b in BytesOf(UTF8Encode(str)) do
    Result := Format('%s%%%.2x', [Result, b]);
end;

Procedure DataCollectionCDS(const fHeadlines, fPrimary_key: string; const fDeli: Char);
var i: Integer;
begin
  gvHeader_list := TStringList.Create;
  gvHeader_list.Clear;
  gvHeader_list.StrictDelimiter := True;//严格按照分隔符进行拆分
  gvHeader_list.Delimiter := fDeli;
  try
    gvHeader_list.DelimitedText := fHeadlines;
    with data_module.cds_mdc do
      begin
        FieldDefs.Clear;
        IndexDefs.Clear;
        close;
        for i := 0 to gvHeader_list.Count-1 do
          begin
            if gvHeader_list.ValueFromIndex[i]='String' then
              FieldDefs.Add(gvHeader_list.Names[i], ftString, 100,False)
            else if gvHeader_list.ValueFromIndex[i]='Float' then
              FieldDefs.Add(gvHeader_list.Names[i], ftFloat, 0, False)
            else if gvHeader_list.ValueFromIndex[i]='Integer' then
              FieldDefs.Add(gvHeader_list.Names[i], ftInteger, 0, False);
            //FieldDefs.Items[i].Size:=20;
          end;
        FieldDefs.Add('mdc_state', ftInteger, 0, False);
        //创建索引字段，多个字段用分号隔开; 默认升序排列
        if fPrimary_key<>'' then
          IndexDefs.Add('idx_Primary1',fPrimary_key,[ixPrimary,IxUnique]);
        IndexDefs.Add('idx_mdc_state', 'mdc_state', []);
        CreateDataSet;
        Open;
      end;
    for i:=0 to frm_main.dbg_collection.Columns.Count-1 do
      begin
        frm_main.dbg_collection.Columns[i].Width := 100;
        frm_main.dbg_collection.Columns[i].Title.Alignment := taCenter;
      end;
  finally

  end;
end;

procedure WorkorderInfoCDS;
var i: Integer;
begin
  with data_module.cds_workorder do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('product_id', ftInteger, 0, True);  //产品编号
      FieldDefs.Add('product_code', ftString, 30, True);  //产品编号
      FieldDefs.Add('input_qty', ftFloat, 0, False);    //计划数量
      FieldDefs.Add('todo_qty', ftFloat, 0, False);   //待做数量
      FieldDefs.Add('output_qty', ftFloat, 0, False);  //产出数量
      FieldDefs.Add('actual_qty', ftFloat, 0,False);  //实做数量
      FieldDefs.Add('badmode_qty', ftFloat, 0, False);   //不良数量
      FieldDefs.Add('weld_count', ftInteger, 0, False);  //焊接次数
      FieldDefs.Add('materiallist', ftString, 1000, False);  //原料列表
      IndexDefs.Add('idx_product_id', 'product_id', [IxPrimary]);
      CreateDataSet;
      Open;
    end;
  for i:=0 to frm_main.dbg_workorder.Columns.Count-1 do
    begin
      if frm_main.dbg_workorder.Columns[i].FieldName='product_id' then
        begin
          frm_main.dbg_workorder.Columns[i].Visible := False;
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='product_code' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '产品编码';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='input_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '计划数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='todo_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '待做数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='output_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '产出数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='actual_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '实做数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='badmode_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '不良数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='weld_count' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '焊接次数';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='materiallist' then
        begin
          frm_main.dbg_workorder.Columns[i].Visible := False;
        end;
      frm_main.dbg_workorder.Columns[i].Title.Alignment := taCenter;
    end;
end;

procedure MaterialsInfoCDS;
var i: Integer;
begin
  with data_module.cds_materials do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('material_id', ftInteger, 0, True);  //原料编号
      FieldDefs.Add('material_code', ftString, 25, True);  //原料编号
      FieldDefs.Add('input_qty', ftFloat, 0, False);    //计划消耗数量
      FieldDefs.Add('consume_qty', ftFloat, 0, False);  //消耗数量
      FieldDefs.Add('material_qty', ftFloat, 0, False);   //工位数量
      FieldDefs.Add('consume_unit', ftFloat, 0,False);  //单位消耗数量
      FieldDefs.Add('leave_qty', ftFloat, 0, False);   //剩余数量
      FieldDefs.Add('materiallot_id', ftInteger, 0, False);  //工位原料批号ID
      FieldDefs.Add('materiallot_name', ftString, 20, False);  //工位原料批号
      IndexDefs.Add('idx_material_id', 'material_id', [IxPrimary]);
      CreateDataSet;
      Open;
    end;
  for i:=0 to frm_main.dbg_materiel.Columns.Count-1 do
    begin
      if frm_main.dbg_materiel.Columns[i].FieldName='material_id' then
        begin
          frm_main.dbg_materiel.Columns[i].Visible := False;
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='material_code' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '原料编码';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='consume_unit' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '单位消耗';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='input_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '计划消耗';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='consume_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '已耗数量';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='leave_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '待耗数量';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='material_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '上料数量';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='materiallot_id' then
        begin
          frm_main.dbg_materiel.Columns[i].Visible := False;
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='materiallot_name' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '原料批号';
        end;
      frm_main.dbg_materiel.Columns[i].Title.Alignment := taCenter;
    end;
end;

procedure BadmodeCDS;
var i: Integer;
begin
  with data_module.cds_badmode do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('badmode_id', ftInteger, 0, True);
      FieldDefs.Add('badmode_name', ftString, 30,False);
      FieldDefs.Add('badmode_qty', ftInteger, 0, True);
      IndexDefs.Add('idx_badmode_name', 'badmode_name', []);
      AggregatesActive:=False;
      with Aggregates.Add do
        begin
          AggregateName:='badmode_qty_sum';
          expression:='Sum(badmode_qty)';
          IndexName:= 'idx_badmode_name';
          GroupingLevel:=0;
          Active:=True;
        end;
      AggregatesActive:=True;
      CreateDataSet;
      Open;
    end;
  for i:=0 to frm_finish.dbg_badmode.Columns.Count-1 do
    begin
      if frm_finish.dbg_badmode.Columns[i].FieldName='badmode_id' then
        begin
          frm_finish.dbg_badmode.Columns[i].Visible := False;
        end;
      if frm_finish.dbg_badmode.Columns[i].FieldName='badmode_name' then
        begin
          frm_finish.dbg_badmode.Columns[i].Title.Caption := '不良模式';
        end;
      if frm_finish.dbg_badmode.Columns[i].FieldName='badmode_qty' then
        begin
          frm_finish.dbg_badmode.Columns[i].Title.Caption := '数量';
        end;
      frm_finish.dbg_badmode.Columns[i].Title.Alignment := taCenter;
    end;
end;

procedure MESLineCDS;
begin
  with data_module.cds_mesline do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('mesline_id', ftInteger, 0, True);
      FieldDefs.Add('mesline_name', ftString, 30,False);
      FieldDefs.Add('mesline_type', ftString, 30,False);
      FieldDefs.Add('stationlist', ftString, 1000, True);
      IndexDefs.Add('idx_mesline_name', 'mesline_name', []);
      CreateDataSet;
      Open;
    end;
    frm_MESLine.dlc_mesline.ListSource := data_module.dsc_mesline;
    frm_MESLine.dlc_mesline.KeyField := 'mesline_id';
    frm_MESLine.dlc_mesline.ListField := 'mesline_name';
end;

procedure StationCDS;
var i: Integer;
begin
  with data_module.cds_station do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('workstation_id', ftInteger, 0, True);
      FieldDefs.Add('workstation_code', ftString, 30, True);
      FieldDefs.Add('workstation_name', ftString, 50, True);
      IndexDefs.Add('idx_workstation_name', 'workstation_name', []);
      CreateDataSet;
      Open;
    end;
  frm_MESLine.dbg_station.DataSource := data_module.dsc_station;
  for i:=0 to frm_MESLine.dbg_station.Columns.Count-1 do
    begin
      if frm_MESLine.dbg_station.Columns[i].FieldName='workstation_id' then
        begin
          frm_MESLine.dbg_station.Columns[i].Visible := False;
        end;
      if frm_MESLine.dbg_station.Columns[i].FieldName='workstation_code' then
        begin
          frm_MESLine.dbg_station.Columns[i].Width := 80;
          frm_MESLine.dbg_station.Columns[i].Title.Caption := '工位编码';
        end;
      if frm_MESLine.dbg_station.Columns[i].FieldName='workstation_name' then
        begin
          frm_MESLine.dbg_station.Columns[i].Width := 500;
          frm_MESLine.dbg_station.Columns[i].Title.Caption := '工位名称';
        end;
      frm_MESLine.dbg_station.Columns[i].Title.Alignment := taCenter;
    end;
end;

function GetFileType(FileName:String):string;
var
  myFile:TMemoryStream;
  Buffer:Word;
begin
  Result := 'Err';
  myFile:=TMemoryStream.Create;
  try
    myFile.LoadFromFile(FileName);
    myFile.Position := 0;                      // 指针文件开头的位置
    if myFile.Size = 0 then Exit;              // 文件大小等于0退出
    myFile.ReadBuffer(Buffer,2);               // 读取文件的前２个字节[低位到高位]，放到Buffer里面
    if Buffer=$4D42 then  Result :='BMP';
    if Buffer=$D8FF then  Result :='JPEG';
    if Buffer=$4947 then  Result :='GIFP';
    if Buffer=$050A then  Result :='PCX';
    if Buffer=$5089 then  Result :='PNG';
    if Buffer=$4238 then  Result :='PSD';
    if Buffer=$A659 then  Result :='RAS';
    if Buffer=$DA01 then  Result :='SGI';
    if Buffer=$4949 then  Result :='TIFF';
  finally
    myFile.Free;                              // 释放内存流对象
  end;
end;

function GetLastLine(fName : String) : String;
var vFile : TFileStream;
    vlist : TStringList;
begin
      vlist := TStringList.Create ;
      vFile := TFileStream.Create(fName, fmOpenRead);
    try
      vFile.Seek(-1024, soFromEnd);
      vlist.LoadFromStream(vFile);  // 这与 LoadFromFile的区别很大, 特别是当文件很大的时候
      result := vlist.Strings[vlist.count-1];
    finally
      FreeAndNil(vFile);
      vlist.Destroy;
    end;
end;

function GetCodeName(fvStart,fvEnd,fvInputStr:String;fvTag:Shortint):String;
var
pos1,pos2:Integer;
begin
  pos1:=PosEx(fvStart,fvInputStr,1);
  pos2:=PosEx(fvEnd,fvInputStr,pos1+Length(fvStart));
  case fvTag of
  0: //返回编码
    begin
      if (pos1>0) and (pos2>0) then
        Result:=Copy(fvInputStr,pos1+Length(fvStart),pos2-pos1-Length(fvStart))
      else
        Result:='';
    end;
  1: //返回名称
    begin
      //起始位置是1表示编码在前面
      if Pos(fvStart,fvInputStr)=1 then
        begin
          Result:=Copy(fvInputStr,pos2+Length(fvEnd),Length(fvInputStr)-pos2);
        end
      else
        begin
          Result:=Copy(fvInputStr,1,pos1-Length(fvStart));
        end;
    end;
  else
    begin
      Result:='';
    end;
  end;
end;

procedure SplitStr(s : string; fSplit : char; fQty : Integer; fTerms : TStringList);
{ This browses a string and divide it into terms whenever the given
  separator is found. The separators will be removed }
  var
  hs : string;
  p, i : integer;
begin
  fTerms.Clear; // First remove all remaining terms
  i:=1;
  if Length(s)=0 then   // Nothin' to separate
    Exit;
  p:=Pos(fSplit,s);
  while P<>0 do
  begin
    if i<fQty then
      begin
        hs:=Copy(s,1,p-1);   // Copy term
        fTerms.Add(hs);       // Add to list
        Delete(s,1,p);       // Remove term and separator
        p:=Pos(fSplit,s); // Search next separator
        i:=i+1;
      end
    else break;
  end;
  if Length(s)>0 then
    fTerms.Add(s);        // Add remaining term
end;

function CDS1LineToJson(srcCDS: TClientDataSet): String;
var
  i: Integer;
  keyValue:String;
begin
  keyValue:= '';
  try
    with srcCDS do
      begin
        if not Active then Open;
        DisableControls;
        Filter := 'mdc_state=' + '0';
        Filtered := True;
        if RecordCount>0 then
          begin
            First;
            keyValue:= '';
            for i := 0 to FieldDefs.Count -1 do
            begin
              case Fields[i].DataType of
                ftString : keyValue:= keyValue + Format('"%s":"%s",',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                ftFloat : keyValue:= keyValue + Format('"%s":%s,',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                ftInteger : keyValue:= keyValue + Format('"%s":%s,',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
                ftBoolean : keyValue:= keyValue + Format('"%s":%s,',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
              else
                keyValue:= keyValue + Format('"%s":"%s",',[Fields[i].FieldName, StringReplace(Fields[i].AsString, #9, ' ', [rfReplaceAll])]);
              end;
            end;
            Edit;
            FieldByName('mdc_state').AsInteger := 1;
            Post;
            Result:= Format('{%s}',[Copy(keyValue, 0, Length(keyValue)-1)]);
          end;
        Filtered := False;
      end;
  finally
    srcCDS.EnableControls;
  end;
end;

//MDC接口协议JSON
function MDCEncode(const fApp_code, fApp_secret, fOperate_time, fData_type, fStation_code, fStaff_code, fStaff_name,
                   fProduct_code, fLot_code, fSerial_number, fMaterial_info, fJob_id, fJob_code, fWorkorder_id, fWorkorder_code: String; fData : String) : String;
var
  keyValue:String;
begin
  keyValue:= '';
  //设备编号
  if fApp_code='' then Exit;
  keyValue:= keyValue + Format('{"%s":"%s",', ['app_code', fApp_code]);
  //设备安全码
  if fApp_secret<>'0' then
    keyValue:= keyValue + Format('"%s":%s,', ['app_secret', fApp_secret]);
  //传输时间戳
    keyValue:= keyValue + Format('"%s":"%s",', ['timstamp', FormatDateTime('yyyy-mm-dd hh:mm:ss',now)]);
    //操作时间
  if fOperate_time<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['operate_time', fOperate_time]);
    //操作设备产生的数据类型
  if fData_type<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['data_type', fData_type]);
    //工位编码
  if fStation_code<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['station_code', fStation_code]);
    //操作工编号
  if fStaff_code<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['staff_code', fStaff_code]);
    //操作工姓名
  if fStaff_name<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['staff_name', fStaff_name]);
    //产品编码
  if fProduct_code<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['product_code', fProduct_code]);
    //产品批号
  if fLot_code<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['lot_code', fLot_code]);
    //产品序列号
  if fSerial_number<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['serial_number', fSerial_number]);
    //原料信息
  if fMaterial_info<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['material_info', fMaterial_info]);
    //主工单ID
  if fJob_id<>'0' then
    keyValue:= keyValue + Format('"%s":%s,', ['job_id', fJob_id]);
    //主工单编号
  if fJob_code<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['job_code', fJob_code]);
    //子工单ID
  if fWorkorder_id<>'0' then
    keyValue:= keyValue + Format('"%s":%s,', ['workorder_id', fWorkorder_id]);
    //子工单编号
  if fWorkorder_code<>'' then
    keyValue:= keyValue + Format('"%s":"%s",', ['workorder_code', fWorkorder_code]);
  Result:= keyValue +'"data":'+ fData + '}';
end;

//按照固定字符串长度拆分，用于短信内容拆分
function WrapWideString(mText:WideString; mLength : Integer): String;
var
J:Integer;
begin
Result:='';
while Length(mText) > mLength do
begin
J := Ord(ByteType(mText, mLength) = mbLeadByte);
Result := Result + #13#10 + Copy(mText, 1, mLength - J);
Delete(mText, 1, mLength - J);
end;
Result := Result + #13#10 + Copy(mText, 1, mLength);
Delete(Result, 1, 2);
end;

Procedure Log(Str:String; Color: TColor);//记录日志文件
var
  vLogPath,vLogFile:String;
begin
  frm_main.lbx_log.Items.AddObject(Str, Pointer(Color));
  frm_main.lbx_log.ItemIndex := frm_main.lbx_log.Items.Count -1;
  vLogPath := ExtractFilePath(paramstr(0)) + 'Log\\';
  vLogFile := FormatDateTime('YYYYMMDD',now)+'.txt';//每天记录一个文件
  if (not DirectoryExists(vLogPath)) then
    begin
      CreateDirectory(pchar(vLogPath), nil);
    end;
  if not fileExists(vLogPath + vLogFile ) then
    begin
      NewTxt(vLogPath + vLogFile );
      AppendTxt(vLogPath + vLogFile ,Str);
    end
  else
    AppendTxt(vLogPath + vLogFile ,Str);
end;

Procedure AppendTxt(filePath:String;Str:String);
Var
   F:Textfile;
Begin
  try
    AssignFile(F, filePath, CP_UTF8);
    Append(F);
    Writeln(F, Str);
  finally
    Closefile(F);
  end;
End;

Procedure NewTxt(filePath:String);
Var
  F : Textfile;
Begin
  try
    AssignFile(F, filePath, CP_UTF8);
    ReWrite(F);
  finally
    Closefile(F);
  end;
End;

function Aurl(CONST fvHost: String; CONST fvPort: Integer): String;
begin
  if fvPort = 80 then
    Result := 'http://' + fvHost + '/jsonrpc'
  else
    Result := 'http://' + fvHost + ':' + IntToStr(fvPort) + '/jsonrpc';
end;

function JsonRPCCall(fvURL: String; CONST fvParams: String): String;
var
  vO: ISuperObject;
  vSendStream: TStringStream;
  vSession: TIdHttp;
begin
  vSendStream := nil;
  vO := SO(
  '{"jsonrpc": "2.0", "method": "call", "params":'+fvParams+'}'
  );
  vSession := TIdHttp.Create(nil);

  try
    vSendStream := TStringStream.Create(vO.AsString);
    vSession.Request.ContentType := 'application/json';
    Result := vSession.Post(fvURL, vSendStream);
  finally
    vSession.Free;
    vSendStream.Free;
  end;
end;

function JsonRPCdblist(fvURL: String): String;
begin
  Result := jsonRPCCall(fvURL, '{"service": "db", "method": "list", "args": []}');
end;

function JsonRPClogin(fvURL: String; CONST fvDB: String; CONST fvUsername: String; CONST fvPassword: String): String;
begin
  Result := jsonRPCCall(fvURL, '{"service": "common", "method": "login", "args": ["'+fvDB+'", "'+fvUsername+'", "'+fvPassword+'"]}');
end;

function JsonRPCobject(fvURL: String; CONST fvArgs: String): String;
begin
  Result := jsonRPCCall(fvURL, '{"service": "object", "method": "execute", "args": '+fvArgs+'}');
end;

function JsonRPCsearch_read(fvURL: String; CONST fvDB: String; CONST fvUserid: Integer; CONST fvPassword: String;
                            CONST fvModel: String; CONST fvDomain: String; CONST fvFields: String  ): String;
begin
  Result := JsonRPCobject(fvURL, '["'+fvDB+'", '+ IntTOStr(fvUserid) +', "'+ fvPassword +'", "'+ fvModel +'", "search_read", '+ fvDomain +','+ fvFields +']');
end;

//MES扫描到、离岗
function scanStaff(CONST fvBarcode: String): String;   //扫码考勤
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_workstation_scanning", "'+ gvApp_code +'", "'+ fvBarcode +'"]');
end;

//查询员工是否在岗
function queryStaffExist : Bool;
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
  vStaff_code, vStaff_name: String;
begin
  vO := SO(JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "get_employeelist", "'+ gvApp_code +'"]'));
  vA := vO['result.employeelist'].AsArray;
  if vA.Length<=0 then
    begin
      Result := False;
    end
  else
    begin
      for i := 0 to vA.Length-1 do
        begin
          vResult := SO(vA[i].AsString);
          if i=0 then
            begin
              gvStaff_code:= vResult.S['employee_code'];
              gvStaff_name:= vResult.S['employee_name'];
            end
          else
            begin
              vStaff_code:= vResult.S['employee_code'];
              vStaff_name:= vResult.S['employee_name'];
              gvStaff_code:= gvStaff_code + #13 + vStaff_code;
              gvStaff_name:= gvStaff_name + #13 + vStaff_name;
            end;
        end;
      Result := True;
    end;
end;

//查询设备信息函数
function queryEquipment : Bool;
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
begin
  vO := SO(JsonRPCsearch_read(Aurl(gvServer_Host,gvServer_Port), gvDatabase, gvUserID, gvPassword, 'aas.equipment.equipment', '[["code","=","'+Trim(gvApp_code)+'"]]', '["id","code","name","active","mesline_id","workstation_id","state"]'));
  vA := vO.A['result'];
  if vA.Length=0 then
    begin
      Result := False;
    end
  else
    begin
      vResult := SO(vA[0].AsString);
      gvApp_id := vResult.I['id'];
      gvApp_code := vResult.S['code'];
      gvApp_name := vResult.S['name'];
      gvApp_state := vResult.S['state'];
      //gvApp_secret :=
      vA := vResult['mesline_id'].AsArray;
      gvMESLine_id := vA[0].AsInteger;
      gvMESLine_name := vA[1].AsString;
      vA := vResult['workstation_id'].AsArray;
      gvWorkstation_id := vA[0].AsInteger;
      gvWorkstation_code := GetCodeName('[', ']', vA[1].AsString,0);
      gvWorkstation_name := GetCodeName('[', ']', vA[1].AsString,1);
      Result := True;
    end;
end;

//查询设备信息函数
function queryLineType(CONST fvLine_code: String): Bool;
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
begin
  vO := SO(JsonRPCsearch_read(Aurl(gvServer_Host,gvServer_Port), gvDatabase, gvUserID, gvPassword, 'aas.mes.line', '[["name","=","'+Trim(fvLine_code)+'"]]', '["id","name","line_type","workday_start","schedule_id","workorder_id"]'));
  vA := vO['result'].AsArray;
  if vA.Length=0 then
    begin
      Result := False;
    end
  else
    begin
      vResult := SO(vA[0].AsString);
      gvline_type := vResult.S['line_type'];
      gvWorkday_start := vResult.S['workday_start'];
      gvSchedule_id := vResult.I['schedule_id'];
      gvWorkorder_id := vResult.I['workorder_id'];
      Result := True;
    end;
end;

//切换生产线或工位
function switchMESLine(CONST fvMesline_id, fvWorkstation_id: Integer): Bool;
var
  vO : ISuperObject;
begin
  vO := SO(JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_setequipment_workstation", "'+ gvApp_code +'", '+ IntToStr(fvMesline_id) +', '+ IntToStr(fvWorkstation_id) +']'));
  Result := vO.B['result.success']
end;

//查询redis函数
function queryRedis(CONST fvQueue_name: String): Bool;
var
  vO, vResult: ISuperObject;
begin
  vO := SO(JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserid) +', "'+ gvPassword +'", "aas.equipment.equipment", "get_redis_settings", "'+ fvQueue_name +'"]'));
  vResult := SO(vO.AsObject.S['result']);
  if vResult.S['result']='false' then
    begin
      Result := FALSE;
      log(DateTimeToStr(now())+', [Eror] 获取MDC地址错误，错误信息：'+ vResult.S['message'], clRed);
    end
  else
    begin
      gvRedis_Port := vResult.I['port'];
      gvRedis_Host := vResult.S['host'];
      Result := TRUE;
    end;
end;

function scanWorkticket(CONST fvBarcode: String): String;
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "get_workstation_workticket", "'+ gvApp_code +'", "'+ fvBarcode +'"]');
end;

function scanContainer(CONST fvBarcode: String): String;   //扫描容器
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_container_scanning", "'+ fvBarcode +'"]');
end;

function getLineWorkorder : String;
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "get_virtual_materiallist", "'+ gvApp_code +'"]');
end;

function feedMaterial(CONST fvBarcode: String): String;
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_feed_onstationclient", "'+ gvApp_code +'", "'+ fvBarcode +'"]');
end;

function getFeedMaterials : String;  //查询设备上料信息
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "get_workstation_materiallist", "'+ gvApp_code +'"]');
end;

function getWorkordConsume(CONST fvWorkorder_id, fvWorkcenter_id: Integer): String;   //工票工单开工
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "loading_consumelist_onclient", '+ IntToStr(fvWorkorder_id) +', '+ IntToStr(fvWorkcenter_id) +']');
end;


function queryBadmode : String;    //获取不良模式
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_loading_badmodelist", "'+ gvApp_code +'"]');
end;

function queryMESLine : String;
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_loading_workstationlist"]');
end;

function workticket_START(CONST fvWorkticket_id, fvApp_id: Integer): String;   //工票工单开工
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_workticket_start_onstationclient", '+ IntToStr(fvWorkticket_id) +', '+ IntToStr(fvApp_id) +']');
end;

function workticket_FINISH(CONST fvWorkticket_id, fvApp_id: Integer; CONST fvCommit_qty : Currency; CONST fvBadmode_lines: String; CONST fvContainer_id: Integer): String;   //工票工单完工
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_workticket_finish_onstationclient", '+ IntToStr(fvWorkticket_id) +', '+ IntToStr(fvApp_id) +', '+ FloatToStr(fvCommit_qty) +', '+fvBadmode_lines+', '+IntToStr(fvContainer_id)+']');
end;

function Virtual_FINISH(CONST  fvProduct_id: Integer; CONST fvOutput_qty : Currency): String;   //子工单虚拟建完工
begin
  Result := JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_vtproduct_output", '+ IntToStr(gvWorkstation_id) +', '+ IntToStr(gvWorkorder_id) +', '+IntToStr(fvProduct_id)+', '+ FloatToStr(fvOutput_qty) +']');
end;

function testingRecord(CONST fvSerialnumber : String; CONST fvOperation_pass : Bool; CONST fvOperate_result: String): Bool;   //保存测试数据
var
  vO : ISuperObject;
begin
  vO := SO(JsonRPCobject(Aurl(gvServer_Host,gvServer_Port), '["'+gvDatabase+'", '+ IntTOStr(gvUserID) +', "'+ gvPassword +'", "aas.equipment.equipment", "action_functiontest", "'+ gvApp_code +'", "'+ fvSerialnumber +'", '+ BoolToStr(fvOperation_pass) +', "'+ fvOperate_result+'"]'));
  Result := vO.B['result.success']
end;

end.
